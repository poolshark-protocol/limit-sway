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
    pub pool_id: b256,
    pub min_tick: I24,
    pub max_tick: I24,
    pub start_price: Q64x64,
    pub start_tick: I24,
}

pub struct MintRangeEvent {
    pub pool_id: b256,
    pub recipient: Identity,
    pub lower: I24,
    pub upper: I24,
    pub position_id: u32,
    pub liquidity_minted: u64,
    pub amount0_delta: I64,
    pub amount1_delta: I64,
}

pub struct BurnRangeEvent {
    pub pool_id: b256,
    pub recipient: Identity,
    pub position_id: u32,
    pub liquidity_burned: u64,
    pub amount0_delta: I64,
    pub amount1_delta: I64,
}

pub struct CompoundRangeEvent {
    pub pool_id: b256,
    pub position_id: u32,
    pub liquidity_compounded: u64,
}

pub struct MintLimitEvent {
    pub pool_id: b256,
    pub recipient: Identity,
    pub lower: I24,
    pub upper: I24,
    pub zero_for_one: bool,
    pub position_id: u32,
    pub epoch_last: u32,
    pub amount_in: u64,
    pub liquidity_minted: u64,
}

pub struct BurnLimitEvent {
    pub pool_id: b256,
    pub recipient: Identity,
    pub position_id: u32,
    pub lower: I24,
    pub upper: I24,
    pub old_claim: I24,
    pub new_claim: I24,
    pub zero_for_one: bool,
    pub liquidity_burned: u64,
    pub token_in_claimed: u64,
    pub token_out_burned: u64,
}

pub struct SwapEvent {
    pub pool_id: b256,
    pub recipient: Identity,
    pub amount_in: u64,
    pub amount_out: u64,
    pub fee_growth_global0: u256,
    pub fee_growth_global1: u256,
    pub price: Q64x64,
    pub liquidity: u64,
    pub fee_amount: u64,
    pub tick_at_price: I24,
    pub zero_for_one: bool,
    pub exact_in: bool,
}

pub struct SyncRangeTickEvent {
    pub pool_id: b256,
    pub fee_growth_global0: u256,
    pub fee_growth_global1: u256,
    pub tick: I24,
}

pub struct SyncLimitPoolEvent {
    pub pool_id: b256,
    pub price: Q64x64,
    pub liquidity: u64,
    pub epoch: u32,
    pub tick_at_price: I24,
    pub is_pool0: bool,
}

pub struct SyncLimitLiquidityEvent {
    pub pool_id: b256,
    pub liquidity_added: u64,
    pub tick: I24,
    pub zero_for_one: bool,
}

pub struct SyncLimitTickEvent {
    pub pool_id: b256,
    pub epoch: u32,
    pub tick: I24,
    pub zero_for_one: bool,
}

pub struct SampleRecorded {
    pub pool_id: b256,
    pub tick_seconds_accum: I64,
    pub seconds_per_liquidity_accum: u256,
}

pub struct SampleCountIncreased {
    pub pool_id: b256,
    pub new_sample_count_max: u16,
}

pub struct ProtocolFeesModifiedEvent {
    pub pool_ids: Vec<b256>,
    pub protocol_swap_fees0: Vec<u16>,
    pub protocol_swap_fees1: Vec<u16>,
    pub protocol_fill_fees0: Vec<u16>,
    pub protocol_fill_fees1: Vec<u16>,
}

pub struct ProtocolFeesCollectedEvent {
    pub pool_ids: Vec<b256>,
    pub token0_fees_collected: Vec<u64>,
    pub token1_fees_collected: Vec<u64>,
}