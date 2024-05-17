library;

use std::{
    context::{this_balance},
    hash::*,
};

use ::types::{
    I24::*,
    I64::*,
    state::{
        global_state::*,
    },
    cache::*,
    positions::range_position::*,
    ticks::{
        ticks::*,
        tick_map::*,
    },
};

struct Balances {
    amount0: u64,
    amount1: u64,
}

struct Sample {
    block_timestamp: u32,
    tick_seconds_accum: I64,
    seconds_per_liquidity_accum: u256,
}

pub fn perform(
    positions: StorageKey<StorageMap<u256, RangePosition>>,
    ticks: StorageKey<StorageMap<I24, Tick>>,
    tick_map: StorageKey<TickMap>,
    samples: StorageVec<Sample>,
    global_state: StorageKey<GlobalState>,
    cache: MintRangeCache,
    params: MintRangeParms,
) -> (I64, I64) {
    // if params.to == zero address, revert CollectToZeroAddress

    // check ticks match spacing

    cache.state = global_state.read();

    if params.position_id > 0 {
        cache.position = positions.get(params.position_id).read();
        if (cache.position.liquidity == 0) {
            // revert PositionNotFound
        }
        if (PositionTokens::balanceOf(
            cache.constants,
            params.to,
            params.position_id
        ) == 0
        ) {
            // revert PositionOwnerMismatch
        }
        cache.owner = params.to;
        params.lower = cache.position.lower;
        params.upper = cache.position.upper;
        // update existing position
        // (
        //     cache.position,
        //     cache.fees_accrued_0,
        //     cache.fees_accrued_1
        // ) = RangePositions::update(
        //     ticks,
        //     cache.position,
        //     cache.state,
        //     cache.constants,
        //     RangePoolStructs::UpdateParams(
        //         params.lower,
        //         params.upper,
        //         params.position_id,
        //         0
        //     )
        // );
    } else {
        params.position_id = cache.state.position_id_next;
        cache.state.position_id_next = cache.state.position_id_next + 1;
        cache.position.lower = params.lower;
        cache.position.upper = params.upper;
        cache.owner = params.to;
    }
    cache.priceLower = constant_product::get_price_at_tick(
        cache.position.lower,
        cache.constants
    );
    cache.priceUpper = constant_product::get_price_at_tick(
        cache.position.upper,
        cache.constants
    );

    save(positions, globalState, cache, params.position_id);
    cache.amount0 = cache.amount0 - params.amount0;
    cache.amount1 = cache.amount1 - params.amount1;

    log(MintRange {
        recipient: contract_id(),
        lower: storage.token0.read(),
        upper: storage.token1.read(),
        position_id,
        liquidity_minted: tick_spacing,
        amount_0_delta: sqrt_price.value.upper,
        amount_1_delta: sqrt_price.value.lower
    });

    cache = RangePositions::add(ticks, samples, tick_map, cache, params);

    save(position, global_state, cache, params.position_id);

    if cache.fees_accrued_0 > 0 || cache.fees_accrued_1 > 0 {
        CollectLib::range(
            cache.position,
            cache.constants,
            cache.owner,
            cache.owner,
            cache.fees_accrued_0,
            cache.fees_accrued_1
        );
    }

    let mut start_balances = Balances {
        amount0: 0,
        amount1: 0
    };

    if cache.amount0 < 0 {
        start_balances.amount0 = balance0(cache);
    }
    if cache.amount1 < 0 {
        start_balances.amount1 = balance1(cache);
    }

    abi(ILimitPoolMintRangeCallback, msg_sender().unwrap()).limit_pool_mint_range_callback(
        cache.amount0,
        cache.amount1,
        params.callback_data
    );

    if cache.amount0 < 0 {
        // revert if cache.amount0 > start_balances.amount0
        if balance0(cache) < start_balances.amount0 + cache.amount0.abs() {
            // revert MintInputAmount0TooLow
        }
    }
    if cache.amount1 < 0 {
                // revert if cache.amount1 > start_balances.amount1
        if balance1(cache) < start_balances.amount1 + cache.amount1.abs() {
            // revert MintInputAmount1TooLow
        }
    }

    (
        I64::from_uint(cache.amount0 + cache.fees_accrued_0),
        I64::from_uint(cache.amount1 + cache.fees_accrued_1)
    )
}

#[storage(write)]
fn save(
   positions: StorageKey<StorageMap<u256, RangePosition>>,
   global_state: StorageKey<GlobalState>,
   cache: MintRangeCache,
   position_id: u32 
) {
    positions.insert(position_id.as_u256(), cache.position);
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