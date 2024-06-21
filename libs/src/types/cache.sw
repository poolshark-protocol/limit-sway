library;

use ::types::{
    I64::*,
    Q64x64::*,
    positions::*,
    state::{
        global_state::*,
        immutables::*,
    },
};

pub struct MintRangeCache {
   pub state: GlobalState,
   pub position: RangePosition,
   pub constants: LimitImmutables,
   pub owner: Identity,
   pub liquidity_minted: u64,
   pub price_lower: Q64x64,
   pub price_upper: Q64x64,
   pub amount0: I64,
   pub amount1: I64,
   pub fees_accrued_0: I64,
   pub fees_accrued_1: I64 
}

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

