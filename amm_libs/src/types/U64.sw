library;

use ::types::U32::{U32Error};
use std::{primitive_conversions::{u64::*,},};

impl u64 {
    pub fn as_u32(self) -> u32 {
        let optional_res_32 = self.try_as_u32();

        require(optional_res_32.is_some(), U32Error::Overflow);

        optional_res_32.unwrap()
    }
}