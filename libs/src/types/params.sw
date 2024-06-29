library;

use std::{
    bytes::*,
};

use ::types::{
    I24::*,
    Q64x64::*,
    U128::*,
};

pub struct MintRangeParams {
    pub to: Identity,
    pub lower: I24,
    pub upper: I24,
    pub position_id: u32,
    pub amount0: u64,
    pub amount1: u64,
    pub callback_data: Bytes
}

pub struct BurnRangeParams {
    pub to: Identity,
    pub position_id: u32,
    pub burn_percent: U128
}

pub struct MintLimitParams {
    pub to: Identity,
    pub amount: u64,
    pub mint_percent: U128,
    pub position_id: u32,
    pub lower: I24,
    pub upper: I24,
    pub zero_for_one: bool,
    pub callback_data: Bytes
}

pub struct BurnLimitParams {
    pub to: Identity,
    pub burn_percent: U128,
    pub position_id: u32,
    pub claim: I24,
    pub zero_for_one: bool
}

pub struct SwapParams {
    pub to: Identity,
    pub price_limit: Q64x64,
    pub amount: u64,
    pub exact_in: bool,
    pub zero_for_one: bool,
    pub callback_data: Bytes
}

pub struct QuoteParams {
    pub price_limit: Q64x64,
    pub amount: u64,
    pub exact_in: bool,
    pub zero_for_one: bool
}

pub struct SnapshotLimitParams {
    pub owner: Identity,
    pub burn_percent: U128,
    pub position_id: u32,
    pub claim: I24,
    pub zero_for_one: bool
}

pub struct FeesParams {
    pub protocol_swap_fee_0: u16,
    pub protocol_swap_fee_1: u16,
    pub protocol_fill_fee_0: u16,
    pub protocol_fill_fee_1: u16,
    pub set_fees_flags: bool
}

pub struct RangeUpdateParams {
    pub lower: I24,
    pub upper: I24,
    pub position_id: u32,
    pub burn_percent: U128,
}