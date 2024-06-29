library;

use ::types::{
    I64::*,
    Q64x64::*,
    positions::range_position::*,
    state::{
        global_state::*,
        immutables::*,
    },
};

use ::positions::range_positions::*;

impl MintRangeCache {
    pub fn new() -> Self {
        Self {
            state: GlobalState::new(),
            position: RangePosition::new(),
            constants: LimitImmutables::new(),
            owner: Identity::zero(),
            liquidity_minted: 0u64,
            price_lower: Q64x64::zero(),
            price_upper: Q64x64::zero(),
            amount0: I64::zero(),
            amount1: I64::zero(),
            fees_accrued_0: I64::zero(),
            fees_accrued_1: I64::zero(),
        }
    }
}