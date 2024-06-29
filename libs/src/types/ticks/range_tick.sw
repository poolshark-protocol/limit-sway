library;

use ::types::{
    I24::*,
    I64::*,
    ticks::{
        tick::*,
    }
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
        ticks: StorageKey<StorageMap<I24, Tick>>,
        samples: StorageKey<StorageVec<Sample>>,
        tick_map: TickMapKeys,
        state: GlobalState,
        constants: LimitImmutables,
        lower: I24,
        upper: I24,
        amount: u64,
    ) -> GlobalState {
        state
    }
}