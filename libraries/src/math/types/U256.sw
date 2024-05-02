library;

use std::{u256::U256};

pub enum U256Error {
    Overflow: (),
    DivideByZero: (),
}

impl U256 {
    pub fn checked_mul(&self, other: &U256) -> Option<U256> {
        let r = &self.0 * &other.0;
        (r.bits() <= 256).then_some(Self(r))
    }

    pub fn checked_div(&self, other: &U256) -> Option<U256> {
        other.0.is_zero().not().then(|| Self(&self.0 / &other.0))
    }

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