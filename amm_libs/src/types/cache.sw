library;

use ::types::{
    I64::*,
    Q64x64::*,
    positions::{
        range_position::*,
    },
    state::{
        global_state::*,
        immutables::*,
    },
};

pub struct MintRangeCache {
   state: GlobalState,
   position: RangePosition,
   constants: LimitImmutables,
   owner: Identity,
   liquidity_minted: u64,
   price_lower: Q64x64,
   price_upper: Q64x64,
   amount0: I64,
   amount1: I64,
   fees_accrued_0: I64,
   fees_accrued_1: I64 
}

