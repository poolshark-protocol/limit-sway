library;

use std::{
    hash::*,
};

pub struct TickMap {
  blocks: u64,
  words: StorageMap<u256, u256>,
  ticks: StorageMap<u256, u256>,
  epochs0: StorageMap<u256, StorageMap<u256, StorageMap<u256, u256>>>,
  epochs1: StorageMap<u256, StorageMap<u256, StorageMap<u256, u256>>>,
}

pub struct TickMapKeys {
  blocks: StorageKey<u64>,
  words: StorageKey<StorageMap<u256, u256>>,
  ticks: StorageKey<StorageMap<u256, u256>>,
  epochs0: StorageKey<StorageMap<u256, StorageMap<u256, StorageMap<u256, u256>>>>,
  epochs1: StorageKey<StorageMap<u256, StorageMap<u256, StorageMap<u256, u256>>>>,
}