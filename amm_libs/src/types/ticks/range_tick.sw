library;

use std::u128::U128;

use ::types::I64::*;
use ::types::I24::*;

pub struct RangeTick {
    fee_growth_outside_0: u256,
    fee_growth_outside_1: u256,
    seconds_per_liquidity_accum_outside: u256,
    tick_seconds_accum_outside: I64,
    liquidity_delta: I64,
    liquidity_absolute: U128
}