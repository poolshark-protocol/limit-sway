library;

use std::{
    asset_id::*,
}

impl core::ops::Ord for AssetId {
    fn lt(self, other: Self) -> bool {
        self.bits() < other.bits()
    }
    fn gt(self, other: Self) -> bool {
        self.bits() > other.bits()
    }
}