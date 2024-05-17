library;

pub struct TickMap {
  blocks: u256,
  words: StorageMap<u256, u256>,
  ticks: StorageMap<u256, u256>,
  epochs0: StorageMap<u256, StorageMap<u256, StorageMap<u256, u256>>>,
  epochs1: StorageMap<u256, StorageMap<u256, StorageMap<u256, u256>>>,
}