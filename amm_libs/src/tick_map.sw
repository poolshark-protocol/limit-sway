library;

use std::hash::*;
use ::math::types::I24::I24;
use ::math::tick_math::{MIN_TICK, MAX_TICK};
use std::{primitive_conversions::{u32::*,},}; 
use std::storage::storage_map::*;

pub struct TickMap {
  blocks: u256,
  words: StorageMap<u256, u256>,
  ticks: StorageMap<u256, u256>,
  epochs0: StorageMap<u256, StorageMap<u256, StorageMap<u256, u256>>>,
  epochs1: StorageMap<u256, StorageMap<u256, StorageMap<u256, u256>>>,
}

pub enum TickKMapError {
  TickIndexOverflow: (),
  TickIndexUnderflow: (),
  BlockIndexOverflow: (),
}

impl TickMap {
  #[storage(read, write)]
  pub fn set(
    ref mut self, 
    tick: I24, 
    tick_spacing: I24,
  ) {
    let (tick_index, word_index, block_index) = get_indices(tick, tick_spacing);

    let mut word = self.ticks.get(word_index).read();
    let new_word = word | (1 << (tick_index & 0xFF));

    if new_word != word {
      self.ticks.insert(word_index, new_word);

      let mut block = self.words.get(block_index).read();
      block |= 1 << (word_index & 0xFF);
      self.words.insert(block_index, block);
      
      self.blocks |= 1 << block_index;
    }
  }
}

#[storage(read, write)]
pub fn get_indices(
  tick_param: I24,
  tick_spacing: I24,
) -> (u256, u256, u256) {
  let min_tick = MIN_TICK();
  let mut tick = tick_param;
  let half_tick_spacing = tick_spacing / I24::from_uint(2);

  require(tick > MAX_TICK(), TickKMapError::TickIndexOverflow);
  require(tick < min_tick, TickKMapError::TickIndexUnderflow);

  if tick % half_tick_spacing != I24::from_uint(0) {
    tick = round(tick, half_tick_spacing);
  }

  let tick_index = ((round(tick, half_tick_spacing) - round(min_tick, half_tick_spacing)) / half_tick_spacing).abs().as_u256();

  let word_index: u256 = tick_index >> 8; // 2^8 ticks per word
  let block_index: u256 = tick_index >> 16; // 2^8 words per block

  require(block_index > 0xffu256, TickKMapError::BlockIndexOverflow);

  (tick_index, word_index, block_index)
}

fn round(
  tick: I24,
  tick_spacing: I24,
) -> I24 {
    return (tick / tick_spacing) * tick_spacing;
}