library;

use std::{
    bytes::*,
    u128::*,
};

use ::types::{
    I24::*,
    Q64x64::*,
};

pub struct MintRangeParams {
    to: Identity,
    lower: I24,
    upper: I24,
    position_id: u32,
    amount0: u64,
    amount1: u64,
    callback_data: Bytes
}

pub struct BurnRangeParams {
    to: Identity,
    position_id: u32,
    burn_percent: U128
}

pub struct MintLimitParams {
    to: Identity,
    amount: u64,
    mint_percent: U128,
    position_id: u32,
    lower: I24,
    upper: I24,
    zero_for_one: bool,
    callback_data: Bytes
}

pub struct BurnLimitParams {
    to: Identity,
    burn_percent: U128,
    position_id: u32,
    claim: I24,
    zero_for_one: bool
}

pub struct SwapParams {
    to: Identity,
    price_limit: Q64x64,
    amount: u64,
    exact_in: bool,
    zero_for_one: bool,
    callback_data: Bytes
}

pub struct QuoteParams {
    price_limit: Q64x64,
    amount: u64,
    exact_in: bool,
    zero_for_one: bool
}

pub struct SnapshotLimitParams {
    owner: Identity,
    burn_percent: U128,
    position_id: u32,
    claim: I24,
    zero_for_one: bool
}

pub struct FeesParams {
    protocol_swap_fee_0: u16,
    protocol_swap_fee_1: u16,
    protocol_fill_fee_0: u16,
    protocol_fill_fee_1: u16,
    set_fees_flags: bool
}