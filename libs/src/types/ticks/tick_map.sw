library;

use std::{
    hash::*,
};

pub struct TickMap {
  pub blocks: u64,
  pub words: StorageMap<u256, u256>,
  pub ticks: StorageMap<u256, u256>,
  pub epochs0: StorageMap<u256, StorageMap<u256, StorageMap<u256, u256>>>,
  pub epochs1: StorageMap<u256, StorageMap<u256, StorageMap<u256, u256>>>,
}

pub struct TickMapKeys {
  pub blocks: StorageKey<u64>,
  pub words: StorageKey<StorageMap<u256, u256>>,
  pub ticks: StorageKey<StorageMap<u256, u256>>,
  pub epochs0: StorageKey<StorageMap<u256, StorageMap<u256, StorageMap<u256, u256>>>>,
  pub epochs1: StorageKey<StorageMap<u256, StorageMap<u256, StorageMap<u256, u256>>>>,
}

impl TickMap {
  pub fn new() -> Self {
    Self {
        blocks: 0u64,
        words: StorageMap::<u256, u256> {},
        ticks: StorageMap::<u256, u256> {},
        epochs0: StorageMap::<u256, StorageMap<u256, StorageMap<u256, u256>>> {},
        epochs1: StorageMap::<u256, StorageMap<u256, StorageMap<u256, u256>>> {},
    }
  }
}