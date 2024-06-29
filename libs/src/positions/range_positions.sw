library;

use std::{
    hash::*,
    storage::{
        storage_vec::*,
        storage_map::*,
        storage_key::*,
    },
};

use ::types::{
    I24::*,
    I64::*,
    U128::*,
    params::*,
    cache::*,
    ticks::{
        tick::*,
        tick_map::*,
    },
    state::{
        global_state::*,
        immutables::*,
    },
    positions::*,
};

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
        ref mut position: RangePosition,
        ticks: StorageKey<StorageMap<I24, Tick>>,
        state: GlobalState,
        constants: LimitImmutables,
        params: RangeUpdateParams
    ) -> (RangePosition, I64, I64) {
        (
            position,
            I64::from_uint(0),
            I64::from_uint(0)
        )
    }

    pub fn add(
        ref mut self,
        ticks: StorageKey<StorageMap<I24, Tick>>,
        samples: StorageKey<StorageVec<Sample>>,
        tick_map: TickMapKeys,
        cache: MintRangeCache,
        params: MintRangeParams
    ) -> MintRangeCache {
        cache
    }
}