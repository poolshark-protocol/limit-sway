contract;

pub mod errors;

use ::errors::LimitPoolErrors;

use std::{
    revert::require,
    identity::*,
    contract_id::*,
    asset_id::*,
    address::Address,
    u128::*,
    u256::*,
    asset::transfer,
    result::*,
    auth::*,
    hash::*,
    logging::log,
    call_frames::{contract_id ,msg_asset_id},
    context::msg_amount,
    alias::SubId,
    storage::{
        storage_vec::*,
        storage_map::*,
        storage_key::*,
    },
};

use limit_libs::{
    types::{
        I24::*,
        I64::*,
        Q64x64::*,
        Q128x128::*,
        state::{
            global_state::*,
        },
        ticks::{
            tick_map::*,
        },
        positions::{
            range_position::*,
        },
        params::*,
        events::*,
        cache::*,
    },
    math::{
        dydx_math::*,
        tick_math::*,
        full_math::*,
    },
};

use limit_calls::{
    range::{
        pool::{
            mint_range_call::*,
        },
    },
};

impl core::ops::Ord for AssetId {
    fn lt(self, other: Self) -> bool {
        self.value < other.value
    }
    fn gt(self, other: Self) -> bool {
        self.value > other.value
    }
}

impl u64 {
    fn as_u128(self) -> U128 {
        U128 {
            upper: 0,
            lower: self
        }
    }
}

impl SubId {
    fn default() -> SubId {
        let default_sub_id: SubId = 0x0000000000000000000000000000000000000000000000000000000000000000;
        default_sub_id
    }
}

struct Position {
    liquidity: U128,
    fee_growth_inside0: Q64x64,
    fee_growth_inside1: Q64x64,
}

struct Tick {
    prev_tick: I24, 
    next_tick: I24,
    liquidity: U128,
    fee_growth_outside0: Q64x64,
    fee_growth_outside1: Q64x64,
    seconds_growth_outside: U128
}

abi LimitPool {
    #[storage(read, write)]
    fn initialize(start_price: Q64x64);

    #[storage(read, write)]
    fn mint_range(params: MintRangeParams) -> (I64, I64);

    #[storage(read, write)]
    fn burn_range(params: BurnRangeParams) -> (I64, I64);

    #[storage(read, write)]
    fn mint_limit(params: MintLimitParams) -> (I64, I64);

    #[storage(read, write)]
    fn burn_limit(params: BurnLimitParams) -> (I64, I64);

    #[storage(read, write)]
    fn swap(params: SwapParams) -> (I64, I64);

    #[storage(read, write)]
    fn fees(params: FeeParams) -> (U128, U128);

    #[storage(read, write)]
    fn increase_sample_count(new_sample_count: u16);

    #[storage(read)]
    fn quote(params: QuoteParams) -> (u64, u64, Q64x64);

    #[storage(read)]
    fn sample(secondsAgo: Vec<u32>) -> (Vec<I24>, Vec<u256>, Q64x64, u64, I24);

    #[storage(read)]
    fn snapshot_range(positionId: u32) -> (I64, u256, u64, u64);

    #[storage(read  )]
    fn snapshot_limit(params: SnapshotLimitParams) -> (u64, u64);
}

// Should be all storage variables
storage {
    token0: AssetId = AssetId{ value: 0x0000000000000000000000000000000000000000000000000000000000000000 },
    token1: AssetId = AssetId{ value: 0x0000000000000000000000000000000000000000000000000000000000000000 },

    unlocked: bool = false,

    tick_spacing: u8 = 10u8,

    ticks: StorageMap<I24, Tick> = StorageMap::<I24, Tick> {},
    positions: StorageMap<u32, RangePosition> = StorageMap::<u32, RangePosition> {},

    range_tick_map: TickMap = TickMap {
        blocks: 0u64,
        words: StorageMap::<u256, u256> {},
        ticks: StorageMap::<u256, u256> {},
        epochs0: StorageMap::<u256, StorageMap<u256, StorageMap<u256, u256>>> {},
        epochs1: StorageMap::<u256, StorageMap<u256, StorageMap<u256, u256>>> {},
    },

    limit_tick_map: TickMap = TickMap {
        blocks: 0u64,
        words: StorageMap::<u256, u256> {},
        ticks: StorageMap::<u256, u256> {},
        epochs0: StorageMap::<u256, StorageMap<u256, StorageMap<u256, u256>>> {},
        epochs1: StorageMap::<u256, StorageMap<u256, StorageMap<u256, u256>>> {},
    },

    samples: StorageVec<Sample> = StorageVec {},

    global_state: GlobalState = GlobalState::new(),
}

impl LimitPool for Contract {
    #[storage(read, write)]
    fn initialize(start_price: Q64x64) {

        log(InitPoolEvent {
            pool_id: contract_id().into(),
            min_tick: I24::zero(),
            max_tick: I24::zero(),
            start_price: Q64x64::zero(),
            start_tick: I24::zero(),
        });
    }

    #[storage(read, write)]
    fn mint_range(params: MintRangeParams) -> (I64, I64) {

        let mut state: GlobalState = storage.global_state.read();

        let range_tick_map_keys = TickMapKeys {
            blocks: storage.range_tick_map.blocks,
            words: storage.range_tick_map.words,
            ticks: storage.range_tick_map.ticks,
            epochs0: storage.range_tick_map.epochs0,
            epochs1: storage.range_tick_map.epochs1,
        };

        // let result = MintRangeCall::perform(
        //     storage.positions,
        //     storage.ticks,
        //     range_tick_map_keys,
        //     storage.samples,
        //     storage.global_state,
        //     MintRangeCache::new(),
        //     params,
        // );

        log(MintRangeEvent {
            pool_id: contract_id().into(),
            recipient: params.to,
            lower: params.lower,
            upper: params.upper,
            position_id: state.position_id_next,
            liquidity_minted: 1u64,
            amount0_delta: I64::from_uint(1u64),
            amount1_delta: I64::from_uint(1u64),
        });

        state.position_id_next = state.position_id_next + 1;

        storage.global_state.write(state);

        (I64::zero(), I64::zero())
    }

    #[storage(read, write)]
    fn burn_range(params: BurnRangeParams) -> (I64, I64) {

        log(BurnRangeEvent {
            pool_id: contract_id().into(),
            recipient: params.to,
            position_id: params.position_id,
            liquidity_burned: 1u64,
            amount0_delta: I64::from_neg(1u64),
            amount1_delta: I64::from_neg(1u64),
        });

        (I64::zero(), I64::zero())
    }

    #[storage(read, write)]
    fn mint_limit(params: MintLimitParams) -> (I64, I64) {

        let mut state: GlobalState = storage.global_state.read();

        log(MintLimitEvent {
            pool_id: contract_id().into(),
            recipient: params.to,
            lower: params.lower,
            upper: params.upper,
            zero_for_one: params.zero_for_one,
            position_id: params.position_id,
            epoch_last: state.epoch,
            amount_in: 1u64,
            liquidity_minted: 1u64,
        });

        state.epoch = state.epoch + 1;

        storage.global_state.write(state);

        (I64::zero(), I64::zero())
    }

    #[storage(read, write)]
    fn burn_limit(params: BurnLimitParams) -> (I64, I64) {

        if params.zero_for_one {
            log(BurnLimitEvent {
                pool_id: contract_id().into(),
                recipient: params.to,
                position_id: params.position_id,
                lower: I24::zero(),
                upper: I24::zero(),
                old_claim: I24::zero(),
                new_claim: I24::zero(), 
                zero_for_one: params.zero_for_one,
                liquidity_burned: 1u64,
                token_in_claimed: 1u64,
                token_out_burned: 1u64,
            });
        } else {
            log(BurnLimitEvent {
                pool_id: contract_id().into(),
                recipient: params.to,
                position_id: params.position_id,
                lower: I24::zero(),
                upper: I24::zero(),
                old_claim: I24::zero(),
                new_claim: I24::zero(), 
                zero_for_one: params.zero_for_one,
                liquidity_burned: 1u64,
                token_in_claimed: 1u64,
                token_out_burned: 1u64,
            });
        }

        (I64::zero(), I64::zero())
    }

    #[storage(read, write)]
    fn swap(params: SwapParams) -> (I64, I64) {

        let mut state: GlobalState = storage.global_state.read();

        log(SwapEvent {
                pool_id: contract_id().into(),
                recipient: params.to,
                amount_in: 1u64,
                amount_out: 1u64,
                fee_growth_global0: state.pool.fee_growth_global0,
                fee_growth_global1: state.pool.fee_growth_global1,
                price: Q64x64::zero(),
                liquidity: 0u64,
                fee_amount: 1u64,
                tick_at_price: I24::zero(),
                zero_for_one: params.zero_for_one,
                exact_in: params.exact_in,
        });

        state.pool.fee_growth_global0 = state.pool.fee_growth_global0 + 1;
        state.pool.fee_growth_global1 = state.pool.fee_growth_global1 + 1;

        storage.global_state.write(state);

        (I64::zero(), I64::zero())
    }

    #[storage(read, write)]
    fn fees(params: FeesParams) -> (u64, u64) {

        (I64::zero(), I64::zero())
    }

    #[storage(read, write)]
    fn increase_sample_count(new_sample_count_max: u16) {

        log(SampleCountIncreased {
            pool_id: contract_id().into(),
            new_sample_count_max
        });
    }

    #[storage(read)]
    fn quote(QuoteParams) -> (u64, u64, Q64x64) {

        (0u64, 0u64, storage.global_state.read().pool.price)
    }


    #[storage(read)]
    fn sample(QuoteParams) -> (Vec<I24>, Vec<u256>, Q64x64, u64, I24) {
        let mut state: GlobalState = storage.global_state.read();

        (Vec::new(), Vec::new(), state.pool.price, 0u64, state.pool.tick_at_price)
    }

    #[storage(read)]
    fn snapshot_range(QuoteParams) -> (I64, u256, u64, u64) {

        (I64::zero(), 0u256, 0u64, 0u64)
    }

    #[storage(read)]
    fn snapshot_limit(QuoteParams) -> (u64, u64) {

        (0u64, 0u64)
    }
}