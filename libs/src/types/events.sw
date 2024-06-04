library;

use std::{
    identity::Identity,
};
use ::types::Q64x64::Q64x64;
use ::types::{
    I24::I24,
    I64::I64,
};

pub struct InitPoolEvent {
    pool_id: b256,
    min_tick: I24,
    max_tick: I24,
    start_price: Q64x64,
    start_tick: I24,
}

pub struct SwapEvent {
    pool_id: b256,
    recipient: Identity,
    amount_in: u64,
    amount_out: u64,
    fee_growth_global_0: u256,
    fee_growth_global_1: u256,
    price: Q64x64,
    liquidity: u64,
    fee_amount: u64,
    tick_at_price: I24,
    zero_for_one: bool,
    exact_in: bool,
}

pub struct MintRangeEvent {
    pool_id: b256,
    recipient: Identity,
    lower: I24,
    upper: I24,
    position_id: u32,
    liquidity_minted: u64,
    amount_0_delta: I64,
    amount_1_delta: I64,
}

pub struct BurnRangeEvent {
    pool_id: b256,
    recipient: Identity,
    position_id: u32,
    liquidity_burned: u64,
    amount_0_delta: I64,
    amount_1_delta: I64,
}

pub struct CompoundRangeEvent {
    pool_id: b256,
    position_id: u32,
    liquidity_compounded: u64,
}

pub struct MintLimitEvent {
    pool_id: b256,
    to: Identity,
    lower: I24,
    upper: I24,
    zero_for_one: bool,
    position_id: u32,
    epoch_last: u32,
    amount_in: u64,
    liquidity_minted: u64,
}

pub struct BurnLimitEvent {
    pool_id: b256,
    to: Identity,
    position_id: u32,
    lower: I24,
    upper: I24,
    old_claim: I24,
    new_claim: I24,
    zero_for_one: bool,
    liquidity_burned: u64,
    token_in_claimed: u64,
    token_out_burned: u64,
}

pub struct SyncRangeTickEvent {
    pool_id: b256,
    fee_growth_global_0: u256,
    fee_growth_global_1: u256,
    tick: I24,
}

pub struct SyncLimitPoolEvent {
    pool_id: b256,
    price: Q64x64,
    liquidity: u64,
    epoch: u32,
    tick_at_price: I24,
    is_pool_0: bool,
}

pub struct SyncLimitLiquidityEvent {
    pool_id: b256,
    liquidity_added: u64,
    tick: I24,
    zero_for_one: bool,
}

pub struct SyncLimitTickEvent {
    pool_id: b256,
    epoch: u32,
    tick: I24,
    zero_for_one: bool,
}

pub struct SampleRecorded {
    pool_id: b256,
    tick_seconds_accum: I64,
    seconds_per_liquidity_accum: u256,
}

pub struct SampleCountIncreased {
    pool_id: b256,
    new_sample_count_max: u16,
}

pub struct ProtocolFeesModifiedEvent {
    pool_ids: Vec<b256>,
    protocol_swap_fees_0: Vec<u16>,
    protocol_swap_fees_1: Vec<u16>,
    protocol_fill_fees_0: Vec<u16>,
    protocol_fill_fees_1: Vec<u16>,
}

pub struct ProtocolFeesCollectedEvent {
    pool_ids: Vec<b256>,
    token_0_fees_collected: Vec<u64>,
    token_1_fees_collected: Vec<u64>,
}