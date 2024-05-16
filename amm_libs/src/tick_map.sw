library;

use std::hash::*;
use ::math::types::I24::I24;

pub struct TickMap {
  blocks: u256,
  words: StorageMap<u256, u256>,
  ticks: StorageMap<u256, u256>,
  epochs0: StorageMap<u256, StorageMap<u256, StorageMap<u256, u256>>>,
  epochs1: StorageMap<u256, StorageMap<u256, StorageMap<u256, u256>>>,
}

#[storage(read, write)]
pub fn set_tick(
  tick_map: StorageKey<TickMap>,
  tick: I24,
  tick_spacing: u32, // @TODO: i24
) {
  
  tick_map.read();
}