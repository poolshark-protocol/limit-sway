library;

use std::hash::*;
use std::u128::U128;
use std::logging::log;
use std::storage::storage_vec::*;

use ::tick_map::*;

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
  tick_at_price: u32, // @TODO: i24,
}

pub struct RangePoolState {
  samples: SampleState,
  fee_growth_global0: u256,
  fee_growth_global1: u256,
  seconds_per_liquidity_accum: u256,
  price: u256,                
  liquidity: U128,            
  tick_seconds_accum: u64, // @TODO: i56,
  tick_at_price: u32, // @TODO: i24,
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
  // global_state,
  // immutables_data,
  start_price: U128
) {
  
  // range_tick_map.write(TickMap {
  //   blocks: 1
  // });

  // limit_tick_map.read();

  // TickMap.set(
  //   rangeTickMap,
  //   ConstantProduct.minTick(constants.tickSpacing),
  //   constants.tickSpacing
  // );

  set_tick(range_tick_map, 1u32, 1u32);
}