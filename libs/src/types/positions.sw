library;

use ::types::{
    I24::*,
};

pub struct RangePosition {
    pub fee_growth_inside_last_0: u256,
    pub fee_growth_inside_last_1: u256,
    pub liquidity: u64,
    pub lower: I24,
    pub upper: I24,
}

impl RangePosition {
    pub fn new() -> Self {
        Self {
            fee_growth_inside_last_0: 0x0u256,
            fee_growth_inside_last_1: 0x0u256,
            liquidity: 0u64,
            lower: I24::zero(),
            upper: I24::zero()
        }
    }
}