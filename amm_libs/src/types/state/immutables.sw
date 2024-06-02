library;

use std::{
    u128::U128,
};

use ::types::I24::*;
use ::types::I64::*;

pub struct PriceBounds {
    min: u256,
    max: u256,
}

pub struct LimitImmutables {
    owner: Address,
    pool_impl: Address,
    factory: Address,
    bounds: PriceBounds,
    token0: AssetId,
    token1: AssetId,
    pool_token: AssetId,
    genesis_time: u32,
    tick_spacing: u32,
    swap_fee: u16
}