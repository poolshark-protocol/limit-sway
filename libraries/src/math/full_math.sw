library;

dep Q128x128;
dep Q64x64;

use std::{result::Result, u128::U128, u256::U256};
use std::revert::revert;
use Q128x128::Q128x128;
use Q64x64::Q64x64;

pub enum FullMathError {
    Overflow: (),
    DivisionByZero: (),
}