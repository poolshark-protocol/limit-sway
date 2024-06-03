library;

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

impl TickMapKeys {
  pub fn from(tick_map: StorageKey<TickMap>) -> Self {
    Self {
      blocks: tick_map.blocks,
      words: tick_map.words,
      ticks: tick_map.ticks,
      epochs0: tick_map.epochs0,
      epochs1: tick_map.epochs1,
    }
  }
}