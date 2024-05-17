library;

pub struct MintRangeCache {
   state: GlobalState,
   position: RangePosition,
   constants: LimitImmutables,
   owner: Address,
   liquidity_minted: U128,
   price_lower: u256,
   price_upper: u256,
   amount0: I64,
   amount1: I64,
   fees_accrued_0: I64,
   fees_accrued_1: I64 
}

