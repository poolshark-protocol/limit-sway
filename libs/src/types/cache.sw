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

