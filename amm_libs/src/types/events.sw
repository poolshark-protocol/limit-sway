library;

pub struct MintRange {
    recipient: Identity,
    lower: I24,
    upper: I24,
    position_id: u32,
    liquidity_minted: U128,
    amount_0_delta: I64,
    amount_1_delta: I64,
}