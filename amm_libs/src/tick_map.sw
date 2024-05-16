library;

use std::hash::*;

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
  tick: u32, // @TODO: i24
  tick_spacing: u32, // @TODO: i24
) {
  
  tick_map.read();
}