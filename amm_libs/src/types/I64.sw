library;

use core::primitives::*;
use std::revert::require;
use std::hash::*;

/// The 64-bit signed integer type.
/// Represented as an underlying u64 value.
/// Actual value is underlying value minus 2^63
/// Max value is 2^63 - 1, min value is -(2^63 - 1)
pub struct I64 {
    underlying: u64,
}

pub enum I64Error {
    Overflow: (),
    DivisionByZero: (),
}

impl std::hash::Hash for I64 {
    fn hash(self, ref mut state: Hasher) {
        self.underlying.hash(state);
    }
}

impl I64 {
    /// The underlying value that corresponds to zero signed value
    pub fn zero_u64() -> u64 {
        // Zero value is 2^63 since the 64th bit is the signed bit
        9223372036854775808u64
    }
}

impl From<u64> for I64 {
    /// Helper function to get a signed number from with an underlying
    fn from(underlying: u64) -> I64 {
        require(underlying < Self::zero_u64(), I64Error::Overflow);
        I64 { underlying }
    }

    fn into(self) -> u64 {
        self.underlying
    }
}

// Main math and comparison Ops

impl core::ops::Eq for I64 {
    fn eq(self, other: Self) -> bool {
        self.underlying == other.underlying
    }
}

impl core::ops::Ord for I64 {
    fn gt(self, other: Self) -> bool {
        // >=0 vs. >=0
        (
            self.underlying > other.underlying &&
            self.underlying <= Self::zero_u64() &&
            other.underlying <= Self::zero_u64()
        ) ||
        // <0 vs. <0
        (
            self.underlying < other.underlying &&
            (
                self.underlying > Self::zero_u64() || 
                other.underlying > Self::zero_u64()
            )
        )
    }
    fn lt(self, other: Self) -> bool {
        // >=0 vs. >=0
        (
            self.underlying < other.underlying &&
            self.underlying <= Self::zero_u64() &&
            other.underlying <= Self::zero_u64()
        ) ||
        // <0 vs. <0
        (
            self.underlying > other.underlying &&
            (
                self.underlying > Self::zero_u64() || 
                other.underlying > Self::zero_u64()
            )
        )
    }
}

impl I64 {
    /// Initializes a new, zeroed I64.
    pub fn zero() -> I64 {
        I64 {
            underlying: I64::zero_u64(),
        }
    }
    pub fn abs(self) -> u64 {
        let is_gt_zero: bool = (self.underlying > I64::zero_u64()) || (self.underlying == I64::zero_u64());
        let abs_pos = self.underlying - I64::zero_u64();
        let abs_neg = I64::zero_u64() + (I64::zero_u64() - self.underlying);
        let abs_value = if is_gt_zero {
            abs_pos
        } else {
            abs_neg
        };
        abs_value
    }
    /// The smallest value that can be represented by this integer type.
    pub fn min() -> I64 {
        // Return 0u64 which is actually −(2^63 - 1)
        I64 {
            underlying: 0u64,
        }
    }
    /// The largest value that can be represented by this type,
    pub fn max() -> I64 {
        // Return max 64-bit number which is actually 2^63 - 1
        I64 {
            underlying: 16777215u64,
        }
    }
    /// The size of this type in bits.
    pub fn bits() -> u64 {
        64u64
    }
    /// Helper function to get a negative value of unsigned numbers
    pub fn from_neg(value: u64) -> I64 {
        I64 {
            underlying: I64::zero_u64() + value,
        }
    }
    /// Helper function to get a positive value from unsigned number
    pub fn from_uint(value: u64) -> I64 {
        // as the minimal value of I64 is 2147483648 (1 << 31) we should add I64::zero_u64() (1 << 31) 
        let underlying: u64 = value;
        require(underlying < I64::zero_u64(), I64Error::Overflow);
        I64 { underlying }
    }
    pub fn from_uint_bool(value: u64, is_neg: bool) -> I64 {
        // as the minimal value of I64 is 2147483648 (1 << 31) we should add I64::zero_u64() (1 << 31) 
        if is_neg {
            return I64 {
                underlying: I64::zero_u64() + value,
            };
        } else {
            let underlying: u64 = value;
            require(underlying < I64::zero_u64(), I64Error::Overflow);
            return I64 { underlying };
        }
    }
}

impl core::ops::Mod for I64 {
    fn modulo(self, other: Self) -> Self {
        let remainder = self.abs() % other.abs();
        if (self.underlying > Self::zero_u64() && other.underlying > Self::zero_u64()) || (self.underlying < Self::zero_u64() && other.underlying < Self::zero_u64()) {
            return I64::from_uint(remainder);
        } else {
            return I64::from_neg(remainder);
        }
    }
}

impl core::ops::Add for I64 {
    /// Add a I64 to a I64. Panics on overflow.
    fn add(self, other: Self) -> Self {
        // subtract 1 << 24 to avoid a double move, then from will perform the overflow check
        Self::from(self.underlying - Self::zero_u64() + other.underlying)
    }
}

impl core::ops::Subtract for I64 {
    /// Subtract a I64 from a I64. Panics of overflow.
    fn subtract(self, other: Self) -> Self {
        let mut res = Self::zero();
        if self.underlying > Self::zero_u64() {
            // add 1 << 31 to avoid loosing the move
            res = Self::from(self.underlying - other.underlying + Self::zero_u64());
        } else {
            // subtract from 1 << 31 as we are getting a negative value
            res = Self::from(Self::zero_u64() - (other.underlying - self.underlying));
        }
        res
    }
}

impl core::ops::Multiply for I64 {
    /// Multiply a I64 with a I64. Panics of overflow.
    fn multiply(self, other: Self) -> Self {
        let mut res = Self::zero();
        if self.underlying >= Self::zero_u64()
            && other.underlying >= Self::zero_u64()
        {
            res = Self::from((self.underlying - Self::zero_u64()) * (other.underlying - Self::zero_u64()) + Self::zero_u64());
        } else if self.underlying < Self::zero_u64()
            && other.underlying < Self::zero_u64()
        {
            res = Self::from((Self::zero_u64() - self.underlying) * (Self::zero_u64() - other.underlying) + Self::zero_u64());
        } else if self.underlying >= Self::zero_u64()
            && other.underlying < Self::zero_u64()
        {
            res = Self::from(Self::zero_u64() - (self.underlying - Self::zero_u64()) * (Self::zero_u64() - other.underlying));
        } else if self.underlying < Self::zero_u64()
            && other.underlying >= Self::zero_u64()
        {
            res = Self::from(Self::zero_u64() - (other.underlying - Self::zero_u64()) * (Self::zero_u64() - self.underlying));
        }

        // Overflow protection
        require((res < Self::max()) || (res == Self::max()), I64Error::Overflow);

        res
    }
}

impl core::ops::Divide for I64 {
    /// Divide a I64 by a I64. Panics if divisor is zero.
    fn divide(self, divisor: Self) -> Self {
        require(divisor != Self::zero(), I64Error::DivisionByZero);
        let mut res = Self::zero();
        if self.underlying >= Self::zero_u64()
            && divisor.underlying > Self::zero_u64()
        {
            res = Self::from((self.underlying - Self::zero_u64()) / (divisor.underlying - Self::zero_u64()) + Self::zero_u64());
        } else if self.underlying < Self::zero_u64()
            && divisor.underlying < Self::zero_u64()
        {
            res = Self::from((Self::zero_u64() - self.underlying) / (Self::zero_u64() - divisor.underlying) + Self::zero_u64());
        } else if self.underlying >= Self::zero_u64()
            && divisor.underlying < Self::zero_u64()
        {
            res = Self::from(Self::zero_u64() - (self.underlying - Self::zero_u64()) / (Self::zero_u64() - divisor.underlying));
        } else if self.underlying < Self::zero_u64()
            && divisor.underlying > Self::zero_u64()
        {
            res = Self::from(Self::zero_u64() - (Self::zero_u64() - self.underlying) / (divisor.underlying - Self::zero_u64()));
        }
        res
    }
}

#[test]
fn I64_from_neg() {
}

#[test]
fn I64_from_uint() {
}

#[test]
fn I64_from_uint_bool() {
}

#[test]
fn I64_add() {
}

#[test]
fn I64_subtract() {
}

#[test]
fn I64_multiply() {
}

#[test]
fn I64_divide() {
}

#[test]
fn I64_mod() {
}

#[test]
fn I64_abs() {
}


