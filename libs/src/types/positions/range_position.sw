library;

use std::{
    u128::U128,
    hash::*,
};

use ::types::{
    I24::*,
    I64::*,
    ticks::tick::*,
    state::{
        global_state::*,
        immutables::*,
    },
};

pub struct RangePosition {
    fee_growth_inside_last_0: u256,
    fee_growth_inside_last_1: u256,
    liquidity: u64,
    lower: I24,
    upper: I24,
}

pub struct RangeUpdateParams {
    lower: I24,
    upper: I24,
    position_id: u32,
    burn_percent: U128,
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

    pub fn update(
        ref mut self,
        ticks: StorageKey<StorageMap<I24, Tick>>,
        state: GlobalState,
        constants: LimitImmutables,
        params: RangeUpdateParams
    ) -> (RangePosition, I64, I64) {
        (
            RangePosition {
                fee_growth_inside_last_0: 0,
                fee_growth_inside_last_1: 0,
                liquidity: 0u64,
                lower: I24::zero(),
                upper: I24::zero(),
            },
            I64::from_uint(0),
            I64::from_uint(0)
        )
    }
}