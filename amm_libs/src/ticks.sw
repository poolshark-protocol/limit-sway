library;

use std::hash::*;
use std::u128::*;
use std::logging::log;
use std::storage::storage_vec::*;
use std::storage::storage_map::*;
use std::storage::storage_key::*;

use ::math::tick_math::{MIN_TICK, MAX_TICK, get_tick_at_price};
use ::math::types::I24::I24;
use ::math::types::Q64x64::Q64x64;
use ::math::types::Q128x128::Q128x128;
use ::tick_map::*;
use ::constants::{TICK_SPACING};

pub struct SampleState {
  index: u16,
  count: u16,
  count_max: u16,
}

pub struct LimitPoolState {
  price: Q64x64,                
  liquidity: U128,            
  protocol_fees: U128,
  protocol_fill_fee: u16,
  tick_at_price: I24,
}

pub struct RangePoolState {
  samples: SampleState,
  fee_growth_global0: Q128x128,
  fee_growth_global1: Q128x128,
  seconds_per_liquidity_accum: u256,
  price: Q64x64,                
  liquidity: U128,            
  tick_seconds_accum: u64, // @TODO: i56,
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

pub struct Sample {
  blockTimestamp: u32,
  // @TODO: int56
  tickSecondsAccum: u64,
  // @TODO: u256?
  secondsPerLiquidityAccum: u256
}

#[storage(read, write)]
pub fn tick_initialize(
  range_tick_map: StorageKey<TickMap>,
  limit_tick_map: StorageKey<TickMap>,
  samples: StorageKey<StorageVec<Sample>>,
  global_state: StorageKey<GlobalState>,
  // immutables_data,
  start_price: Q64x64
) {
  let min_tick = MIN_TICK();
  let max_tick = MAX_TICK();
  let tick_spacing = I24::from(TICK_SPACING);

  let mut range = range_tick_map.read();
  let original_range_blocks = range.blocks;
  range.set(min_tick, tick_spacing);
  range.set(max_tick, tick_spacing);

  if range.blocks != original_range_blocks {
    range_tick_map.write(range);
  }

  // let mut limit = limit_tick_map.read();

  // limit.set(min_tick, tick_spacing);
  // limit.set(max_tick, tick_spacing);
  // limit_tick_map.write(limit);

  // let mut state: GlobalState = global_state.read();

  // state.pool.price = start_price;
  // state.pool_0.price = start_price;
  // state.pool_1.price = start_price;

  // let start_tick = get_tick_at_price(start_price);
 
  // state.pool.tick_at_price = start_tick;
  // state.pool_0.tick_at_price = start_tick;
  // state.pool_1.tick_at_price = start_tick;

  // // @TODO: samples

  // global_state.write(state);

}
