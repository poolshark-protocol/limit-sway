library;

use std::u128::U128;

use ::types::I24::*;

pub struct RangePosition {
    fee_growth_inside_last_0: u256,
    fee_growth_inside_last_1: u256,
    liquidity: U128,
    lower: I24,
    upper: I24,
}

pub struct RangeUpdateParams {
    lower: I24,
    upper: I24,
    position_id: u32,
    burn_percent: U128
}

impl RangePosition {
    pub fn update(
        ref mut self,
        ticks: StorageKey<StorageMap<I24, Tick>>,
        state: GlobalState,
        constants: LimitImmutables,
        params: RangeUpdateParams
    )
}