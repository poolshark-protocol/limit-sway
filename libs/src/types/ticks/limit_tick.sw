library;

use ::types::{
    I24::*,
    I64::*,
    U128::*,
};

pub struct LimitTick {
    price_at: u256,
    liquidity_delta: I64,
    liquidity_absolute: U128
}