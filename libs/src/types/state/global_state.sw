library;

use ::types::{
  I24::*,
  I64::*,
  Q64x64::*,
  U128::*,
};

pub struct Sample {
  block_timestamp: u32,
  tick_seconds_accum: I64,
  seconds_per_liquidity_accum: u256
}

pub struct SampleState {
  index: u16,
  count: u16,
  count_max: u16,
}

pub struct LimitPoolState {
  price: Q64x64,                
  liquidity: u64,          
  protocol_fees: u64,
  protocol_fill_fee: u16,
  tick_at_price: I24,
}

pub struct RangePoolState {
  samples: SampleState,
  fee_growth_global0: u256,
  fee_growth_global1: u256,
  seconds_per_liquidity_accum: u256,
  price: Q64x64,                
  liquidity: u64,            
  tick_seconds_accum: I64,
  tick_at_price: I24,
  swap_fee: u16,
  protocol_swap_fee0: u16,
  protocol_swap_fee1: u16,
}

pub struct GlobalState {
  pub pool: RangePoolState,
  pub pool_0: LimitPoolState,
  pub pool_1: LimitPoolState,
  pub liquidity_global: u64,
  pub position_id_next: u32,
  pub epoch: u32,
  pub unlocked: u8,
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
            price: Q64x64::zero(),
            liquidity: 0u64,
            tick_seconds_accum: I64::zero(), // @TODO: change to i56
            tick_at_price: I24::zero(), // @TODO: change to i24
            swap_fee: 0u16,
            protocol_swap_fee0: 0u16,
            protocol_swap_fee1: 0u16,
        },
        pool_0: LimitPoolState {
            price: Q64x64::zero(),
            liquidity: 0u64,
            protocol_fees: 0u64,
            protocol_fill_fee: 0u16,
            tick_at_price: I24::zero(), // @TODO: change to i24
        },
        pool_1: LimitPoolState {
            price: Q64x64::zero(),
            liquidity: 0u64,
            protocol_fees: 0u64,
            protocol_fill_fee: 0u16,
            tick_at_price: I24::zero(), // @TODO: change to i24
        },
        liquidity_global: 0u64,
        position_id_next: 0u32,
        epoch: 0u32,
        unlocked: 0u8,
    }
  }
}