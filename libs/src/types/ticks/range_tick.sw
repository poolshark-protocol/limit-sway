library;

use ::types::{
    I24::*,
    I64::*,
};

pub struct RangeTick {
    fee_growth_outside_0: u256,
    fee_growth_outside_1: u256,
    seconds_per_liquidity_accum_outside: u256,
    tick_seconds_accum_outside: I64,
    liquidity_delta: I64,
    liquidity_absolute: u64
}

impl RangeTick {
    pub fn insert(
        ticks,
        samples,
        tick_map,
        state,
        constants,
        lower,
        upper,
        amount
    )
}