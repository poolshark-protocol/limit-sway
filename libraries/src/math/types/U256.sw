library;

use std::{u256::*};

pub enum U256Error {
    Overflow: (),
    DivideByZero: (),
}

impl U256 {
    pub fn mul(self, other: U256) -> U256 {
        let optional_res_256 = self.checked_mul(other);

        require(optional_res_256.is_some(), U256Error::DivideByZero);

        optional_res_256.unwrap()
    }

    pub fn div(self, other: U256) -> U256 {
        let optional_res_256 = self.checked_div(other);

        require(optional_res_256.is_some(), U256Error::Overflow);

        optional_res_256.unwrap()
    }
}