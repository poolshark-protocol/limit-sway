library;

use std::u128::U128;

use ::types::I64::*;
use ::types::I24::*;

pub struct LimitTick {
    price_at: u256,
    liquidity_delta: I64,
    liquidity_absolute: U128
}