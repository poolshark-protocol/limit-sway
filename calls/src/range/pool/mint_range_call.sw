library;

use std::{
    context::{this_balance},
    hash::*,
    storage::{
        storage_vec::*,
        storage_map::*,
        storage_key::*,
    },
    identity::*,
    call_frames::{
        msg_asset_id
    },
    contract_id::*,
};

use limit_libs::{
    types::{
        I24::*,
        I64::*,
        U128::*,
        state::{
            global_state::*,
        },
        cache::*,
        params::MintRangeParams,
        positions::*,
        position::range_positions::*,
        ticks::{
            tick::*,
            tick_map::*,
        },
        events::MintRangeEvent,
        identity::*,
        sub_id::*,
    },
    math::{
        tick_math::get_price_at_tick,
        constant_product::*,
    },
    abis::{
        callbacks::ILimitPoolMintRangeCallback
    },
};

struct Balances {
    amount0: u64,
    amount1: u64,
}



pub struct MintRangeCall {
    value: u64,
}

impl MintRangeCall {
    #[storage(read,write)]
    pub fn perform(
        positions: StorageKey<StorageMap<u32, RangePosition>>,
        ticks: StorageKey<StorageMap<I24, Tick>>,
        tick_map: TickMapKeys,
        samples: StorageKey<StorageVec<Sample>>,
        global_state: StorageKey<GlobalState>,
        ref mut cache: MintRangeCache,
        ref mut params: MintRangeParams,
    ) -> (I64, I64) {
        require(params.to != Identity::zero(), "INPUT ERROR: Cannot collect to zero address.");

        // check ticks match spacing
        ConstantProduct::check_ticks(
            params.lower,
            params.upper,
            cache.constants.tick_spacing
        );

        cache.state = global_state.read();

        if params.position_id > 0u32 {
            cache.position = positions.get(params.position_id).read();
            require(cache.position.liquidity != 0u64, "INPUT ERROR: No position with liquidity found.");
            // check msg_asset_id matches contract_id + position_id
            require(msg_asset_id() == AssetId::new(ContractId::this(), SubId::from(params.position_id)), "INPUT ERROR: Position owner mismatch.");
            cache.owner = params.to;
            params.lower = cache.position.lower;
            params.upper = cache.position.upper;
            // update existing position
            let update_result = cache.position.update(
                ticks,
                cache.state,
                cache.constants,
                RangeUpdateParams {
                    lower: params.lower,
                    upper: params.upper,
                    position_id: params.position_id,
                    burn_percent: U128::zero(),
                }
            );
            cache.position = update_result.0;
            cache.fees_accrued_0 = update_result.1;
            cache.fees_accrued_1 = update_result.2;
        } else {
            params.position_id = cache.state.position_id_next;
            cache.state.position_id_next = cache.state.position_id_next + 1;
            cache.position.lower = params.lower;
            cache.position.upper = params.upper;
            cache.owner = params.to;
        }
        cache.price_lower = get_price_at_tick(
            cache.position.lower,
            cache.constants
        );
        cache.price_upper = get_price_at_tick(
            cache.position.upper,
            cache.constants
        );

        save(positions, global_state, cache, params.position_id);
        cache.amount0 = cache.amount0 - I64::from_uint(params.amount0);
        cache.amount1 = cache.amount1 - I64::from_uint(params.amount1);

        log(MintRangeEvent {
            pool_id: ContractId::this().into(),
            recipient: params.to,
            lower: params.lower,
            upper: params.upper,
            position_id: params.position_id,
            liquidity_minted: cache.liquidity_minted,
            amount0_delta: cache.amount0 + cache.fees_accrued_0,
            amount1_delta: cache.amount1 + cache.fees_accrued_1,
        });

        // // cache = RangePositions::add(ticks, samples, tick_map, cache, params);

        save(positions, global_state, cache, params.position_id);

        if cache.fees_accrued_0 > I64::zero() || cache.fees_accrued_1 > I64::zero() {
        //     // CollectLib::range(
        //     //     cache.position,
        //     //     cache.constants,
        //     //     cache.owner,
        //     //     cache.owner,
        //     //     cache.fees_accrued_0,
        //     //     cache.fees_accrued_1
        //     // );
        }

        let mut start_balances = Balances {
            amount0: 0,
            amount1: 0
        };

        if cache.amount0 < I64::zero() {
            start_balances.amount0 = balance0(cache);
        }
        if cache.amount1 < I64::zero() {
            start_balances.amount1 = balance1(cache);
        }

        abi(ILimitPoolMintRangeCallback, msg_sender().unwrap().bits()).limit_pool_mint_range_callback(
            cache.amount0,
            cache.amount1,
            params.callback_data
        );

        if cache.amount0 < I64::zero() {
            // revert if cache.amount0 > start_balances.amount0
            if balance0(cache) < start_balances.amount0 + cache.amount0.abs() {
                // revert MintInputAmount0TooLow
            }
        }
        if cache.amount1 < I64::zero() {
            // revert if cache.amount1 > start_balances.amount1
            if balance1(cache) < start_balances.amount1 + cache.amount1.abs() {
                // revert MintInputAmount1TooLow
            }
        }

        (
            cache.amount0 + cache.fees_accrued_0,
            cache.amount1 + cache.fees_accrued_1
        )
    }
}

#[storage(write)]
fn save(
    positions: StorageKey<StorageMap<u32, RangePosition>>,
    global_state: StorageKey<GlobalState>,
    cache: MintRangeCache,
    position_id: u32 
) {
    positions.insert(position_id, cache.position);
    global_state.write(cache.state);
}

fn balance0(
    cache: MintRangeCache
) -> u64 {
    this_balance(cache.constants.token0)
}

fn balance1(
    cache: MintRangeCache
) -> u64 {
    this_balance(cache.constants.token1)
}
