library;

use std::{
    u128::U128,
};

use ::types::I24::*;
use ::types::I64::*;

struct PriceBounds {
    min: u256,
    max: u256,
}

struct LimitImmutables {
    owner: Address,
    pool_impl: Address,
    factory: Address,
    bounds: PriceBounds,
    token0: AssetId,
    token1: AssetId,
    pool_token: AssetId,
    genesis_time: u32,
    tick_spacing: I24,
    swap_fee: u16
}