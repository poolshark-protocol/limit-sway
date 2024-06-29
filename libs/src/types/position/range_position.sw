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

pub struct RangeUpdateParams {
    pub lower: I24,
    pub upper: I24,
    pub position_id: u32,
    pub burn_percent: U128,
}

impl RangePosition {
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