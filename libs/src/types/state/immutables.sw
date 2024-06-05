library;

use std::{
    u128::U128,
};

use ::types::I24::*;
use ::types::I64::*;
use ::types::Q64x64::*;
use ::types::identity::*;

pub struct PriceBounds {
    min: Q64x64,
    max: Q64x64,
}

pub struct LimitImmutables {
    owner: Identity,
    bounds: PriceBounds,
    token0: AssetId,
    token1: AssetId,
    tick_spacing: u8,
    swap_fee: u16,
}

impl LimitImmutables {
    pub fn new() -> Self {
        LimitImmutables {
            owner: Identity::zero(),
            bounds: PriceBounds {
                min: Q64x64::zero(),
                max: Q64x64::zero(),
            },
            token0: AssetId::default(),
            token1: AssetId::default(),
            tick_spacing: 0u8,
            swap_fee: 0u16,
        }
    }
}