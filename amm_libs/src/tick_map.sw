library;

use std::hash::*;
use ::math::types::I24::I24;
use ::math::tick_math::{MIN_TICK, MAX_TICK};
use std::{primitive_conversions::{u32::*,},}; 
use std::storage::storage_map::*;

pub struct TickMap {
  blocks: u64,
  words: StorageMap<u64, u64>,
  ticks: StorageMap<u64, u64>,
  epochs0: StorageMap<u256, StorageMap<u256, StorageMap<u256, u256>>>,
  epochs1: StorageMap<u256, StorageMap<u256, StorageMap<u256, u256>>>,
}

pub struct TickMapKeys {
  blocks: StorageKey<u64>,
  words: StorageKey<StorageMap<u64, u64>>,
  ticks: StorageKey<StorageMap<u64, u64>>,
  // epochs0: StorageKey<StorageMap<u256, StorageMap<u256, StorageMap<u256, u256>>>>,
  // epochs1: StorageKey<StorageMap<u256, StorageMap<u256, StorageMap<u256, u256>>>>,
}

pub enum TickKMapError {
  TickIndexOverflow: (),
  TickIndexUnderflow: (),
  BlockIndexOverflow: (),
}

impl TickMapKeys {
  #[storage(read, write)]
  pub fn set(
    self, 
    tick: I24, 
    tick_spacing: I24,
  ) {
    let (tick_index, word_index, block_index) = get_indices(tick, tick_spacing);

    let mut word = self.ticks.get(word_index).read();
    let new_word = word | (1 << (tick_index & 0xFF));

    if new_word != word {
      self.ticks.insert(word_index, new_word);

      let mut block = self.words.get(block_index).read();
      block = block | 1 << (word_index & 0xFF);
      self.words.insert(block_index, block);
      
      let current_blocks = self.blocks.read();
      self.blocks.write(current_blocks | (1 << block_index));
    }
  }
}

pub fn get_indices(
  tick_param: I24,
  tick_spacing: I24,
) -> (u64, u64, u64) {
  let min_tick = MIN_TICK();
  let mut tick = tick_param;
  let half_tick_spacing = tick_spacing / I24::from_uint(2);

  require(tick > MAX_TICK(), TickKMapError::TickIndexOverflow);
  require(tick < min_tick, TickKMapError::TickIndexUnderflow);

  if tick % half_tick_spacing != I24::from_uint(0) {
    tick = round(tick, half_tick_spacing);
  }

  let tick_index = ((round(tick, half_tick_spacing) - round(min_tick, half_tick_spacing)) / half_tick_spacing).abs().as_u64();

  let word_index = tick_index >> 8; // 2^8 ticks per word
  let block_index = tick_index >> 16; // 2^8 words per block

  require(block_index > 0xFF, TickKMapError::BlockIndexOverflow);

  (tick_index, word_index, block_index)
}

fn round(
  tick: I24,
  tick_spacing: I24,
) -> I24 {
    return (tick / tick_spacing) * tick_spacing;
}