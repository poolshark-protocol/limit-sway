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
    params::*,
    cache::*,
    ticks::{
        range_tick::*,
        tick::*,
        tick_map::*,
    },
    state::{
        global_state::*,
        immutables::*,
    },
};

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