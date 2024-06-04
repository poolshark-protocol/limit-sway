library;

use std::{
    u128::U128,
};

use ::types::I24::*;
use ::types::I64::*;

pub struct Sample {
  blockTimestamp: u32,
  // @TODO: int56
  tickSecondsAccum: u64,
  // @TODO: u256?
  secondsPerLiquidityAccum: u256
}

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
  swap_fee: u16,
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

impl GlobalState {
  pub fn new() -> Self {
    GlobalState {
        pool: RangePoolState {
            samples: SampleState {
                index: 0u16,
                count: 0u16,
                count_max: 0u16,
            },
            fee_growth_global0: 0x0u256,
            fee_growth_global1: 0x0u256,
            seconds_per_liquidity_accum: 0x0u256,
            price: 0x0u256,
            liquidity: U128{upper: 0, lower: 0},
            tick_seconds_accum: I64::zero(), // @TODO: change to i56
            tick_at_price: I24::zero(), // @TODO: change to i24
            swap_fee: 0u16,
            protocol_swap_fee0: 0u16,
            protocol_swap_fee1: 0u16,
        },
        pool_0: LimitPoolState {
            price: 0x0u256,
            liquidity: U128{upper: 0, lower: 0},
            protocol_fees: U128{upper: 0, lower: 0},
            protocol_fill_fee: 0u16,
            tick_at_price: I24::zero(), // @TODO: change to i24
        },
        pool_1: LimitPoolState {
            price: 0x0u256,
            liquidity: U128{upper: 0, lower: 0},
            protocol_fees: U128{upper: 0, lower: 0},
            protocol_fill_fee: 0u16,
            tick_at_price: I24::zero(), // @TODO: change to i24
        },
        liquidity_global: U128{upper: 0, lower: 0},
        position_id_next: 0u32,
        epoch: 0u32,
        unlocked: 0u8,
    }
  }
}