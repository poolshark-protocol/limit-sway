library;

use std::{identity::Identity, contract_id::ContractId, u128::U128};
use amm_libs::types::Q64x64::Q64x64;
use amm_libs::types::I24::I24;

pub struct InitPoolEvent {
    pool: ContractId,
    token0: AssetId,
    token1: AssetId,
    swap_fee: u16,
    tick_spacing: u8,
    start_price: Q64x64,
    start_tick: I24
}

pub struct SwapEvent {
    pool: ContractId,
    sender: Identity,
    recipient: Identity,
    token0_amount: u64,
    token1_amount: u64,
    liquidity: U128,
    tick: I24,
    sqrt_price: Q64x64
}

pub struct MintEvent {
    pool: ContractId,
    sender: Identity,
    recipient: Identity,
    token0_amount: u64,
    token1_amount: u64,
    liquidity_minted: U128,
    tick_lower: I24,
    tick_upper: I24
}

pub struct BurnEvent {
    pool: ContractId,
    sender: Identity,
    token0_amount: u64,
    token1_amount: u64,
    liquidity_burned: U128,
    tick_lower: I24,
    tick_upper: I24
}

pub struct FlashEvent {
    fee_growth_global0: Q64x64,
    fee_growth_global1: Q64x64
}