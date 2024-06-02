library;

use std::{
    u128::U128,
};

use ::types::I24::*;
use ::types::I64::*;

pub struct SampleState {
  index: u16,
  count: u16,
  count_max: u16,
}

pub struct LimitPoolState {
  price: u256,                
  liquidity: U128,            
  protocol_fees: U128,
  protocol_fill_fee: u16,
  tick_at_price: I24,
}

pub struct RangePoolState {
  samples: SampleState,
  fee_growth_global0: u256,
  fee_growth_global1: u256,
  seconds_per_liquidity_accum: u256,
  price: u256,                
  liquidity: U128,            
  tick_seconds_accum: I64, // @TODO: i56,
  tick_at_price: I24,
  protocol_swap_fee0: u16,
  protocol_swap_fee1: u16,
}

pub struct GlobalState {
  pool: RangePoolState,
  pool_0: LimitPoolState,
  pool_1: LimitPoolState,
  liquidity_global: U128,
  position_id_next: u32,
  epoch: u32,
  unlocked: u8,
}