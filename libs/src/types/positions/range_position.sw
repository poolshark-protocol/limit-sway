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
};

pub struct RangePosition {
    pub fee_growth_inside_last_0: u256,
    pub fee_growth_inside_last_1: u256,
    pub liquidity: u64,
    pub lower: I24,
    pub upper: I24,
}