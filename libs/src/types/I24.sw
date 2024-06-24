library;

use core::primitives::*;
use std::revert::require;
use std::hash::*;

/// The 24-bit signed integer type.
/// Represented as an underlying u32 value.
/// Actual value is underlying value minus 2 ^ 24
/// Max value is 2 ^ 24 - 1, min value is - 2 ^ 24
pub struct I24 {
    pub underlying: u3,
}

pub enum I24Error {
    Overflow: (),
    DivisionByZero: (),
}

impl I24 {
    /// The underlying value that corresponds to zero signed value
    pub fn zero_u32() -> u32 {
        // So zero value must be 8,388,608 to cover the full range
        8388608u32
    }
}

impl From<u32> for I24 {
    /// Helper function to get a signed number from with an underlying
    fn from(underlying: u32) -> I24 {
        require(underlying < Self::zero_u32(), I24Error::Overflow);
        I24 { underlying }
    }
}

// Main math and comparison Ops

impl core::ops::Eq for I24 {
    fn eq(self, other: Self) -> bool {
        self.underlying == other.underlying
    }
}

impl core::ops::Ord for I24 {
    fn gt(self, other: Self) -> bool {
        // >=0 vs. >=0
        (
            self.underlying > other.underlying &&
            self.underlying <= Self::zero_u32() &&
            other.underlying <= Self::zero_u32()
        ) ||
        // <0 vs. <0
        (
            self.underlying < other.underlying &&
            (
                self.underlying > Self::zero_u32() || 
                other.underlying > Self::zero_u32()
            )
        )
    }
    fn lt(self, other: Self) -> bool {
        // >=0 vs. >=0
        (
            self.underlying < other.underlying &&
            self.underlying <= Self::zero_u32() &&
            other.underlying <= Self::zero_u32()
        ) ||
        // <0 vs. <0
        (
            self.underlying > other.underlying &&
            (
                self.underlying > Self::zero_u32() || 
                other.underlying > Self::zero_u32()
            )
        )
    }
}

impl I24 {
    fn into(self) -> u32 {
        self.underlying
    }

    pub fn ge(self, other: Self) -> bool {
        // >=0 vs. >=0
        (
            self.underlying >= other.underlying &&
            self.underlying <= Self::zero_u32() &&
            other.underlying <= Self::zero_u32()
        ) ||
        // <0 vs. <0
        (
            self.underlying <= other.underlying &&
            (
                self.underlying > Self::zero_u32() || 
                other.underlying > Self::zero_u32()
            )
        )
    }
    pub fn le(self, other: Self) -> bool {
        // >=0 vs. >=0
        (
            self.underlying <= other.underlying &&
            self.underlying <= Self::zero_u32() &&
            other.underlying <= Self::zero_u32()
        ) ||
        // <0 vs. <0
        (
            self.underlying >= other.underlying &&
            (
                self.underlying > Self::zero_u32() || 
                other.underlying > Self::zero_u32()
            )
        )
    }
}

impl std::hash::Hash for I24 {
    fn hash(self, ref mut state: Hasher) {
        self.underlying.hash(state);
    }
}

impl I24 {
    /// Initializes a new, zeroed I24.
    pub fn zero() -> I24 {
        I24 {
            underlying: I24::zero_u32(),
        }
    }
    pub fn abs(self) -> u32 {
        let is_gt_zero: bool = (self.underlying > I24::zero_u32()) || (self.underlying == I24::zero_u32());
        let abs_pos = self.underlying - I24::zero_u32();
        let abs_neg = I24::zero_u32() + (I24::zero_u32() - self.underlying);
        let abs_value = if is_gt_zero {
            abs_pos
        } else {
            abs_neg
        };
        abs_value
    }
    /// The smallest value that can be represented by this integer type.
    pub fn min() -> I24 {
        // Return 0u32 which is actually −8,388,608
        I24 {
            underlying: 0u32,
        }
    }
    /// The largest value that can be represented by this type,
    pub fn max() -> I24 {
        // Return max 24-bit number which is actually 8,388,607
        I24 {
            underlying: 16777215u32,
        }
    }
    /// The size of this type in bits.
    pub fn bits() -> u32 {
        24u32
    }
    /// Helper function to get a negative value of unsigned numbers
    pub fn from_neg(value: u32) -> I24 {
        I24 {
            underlying: I24::zero_u32() + value,
        }
    }
    /// Helper function to get a positive value from unsigned number
    pub fn from_uint(value: u32) -> I24 {
        // as the minimal value of I24 is 2147483648 (1 << 31) we should add I24::zero_u32() (1 << 31) 
        let underlying: u32 = value;
        require(underlying < I24::zero_u32(), I24Error::Overflow);
        I24 { underlying }
    }
    pub fn from_uint_bool(value: u32, is_neg: bool) -> I24 {
        // as the minimal value of I24 is 2147483648 (1 << 31) we should add I24::zero_u32() (1 << 31) 
        if is_neg {
            return I24 {
                underlying: I24::zero_u32() + value,
            };
        } else {
            let underlying: u32 = value;
            require(underlying < I24::zero_u32(), I24Error::Overflow);
            return I24 { underlying };
        }
    }
}

impl core::ops::Mod for I24 {
    fn modulo(self, other: Self) -> Self {
        let remainder = self.abs() % other.abs();
        if (self.underlying > Self::zero_u32() && other.underlying > Self::zero_u32()) || (self.underlying < Self::zero_u32() && other.underlying < Self::zero_u32()) {
            return I24::from_uint(remainder);
        } else {
            return I24::from_neg(remainder);
        }
    }
}

impl core::ops::Add for I24 {
    /// Add a I24 to a I24. Panics on overflow.
    fn add(self, other: Self) -> Self {
        // subtract 1 << 24 to avoid a double move, then from will perform the overflow check
        Self::from(self.underlying - Self::zero_u32() + other.underlying)
    }
}

impl core::ops::Subtract for I24 {
    /// Subtract a I24 from a I24. Panics of overflow.
    fn subtract(self, other: Self) -> Self {
        let mut res = Self::zero();
        if self.underlying > Self::zero_u32() {
            // add 1 << 31 to avoid loosing the move
            res = Self::from(self.underlying - other.underlying + Self::zero_u32());
        } else {
            // subtract from 1 << 31 as we are getting a negative value
            res = Self::from(Self::zero_u32() - (other.underlying - self.underlying));
        }
        res
    }
}

impl core::ops::Multiply for I24 {
    /// Multiply a I24 with a I24. Panics of overflow.
    fn multiply(self, other: Self) -> Self {
        let mut res = Self::zero();
        if self.underlying >= Self::zero_u32()
            && other.underlying >= Self::zero_u32()
        {
            res = Self::from((self.underlying - Self::zero_u32()) * (other.underlying - Self::zero_u32()) + Self::zero_u32());
        } else if self.underlying < Self::zero_u32()
            && other.underlying < Self::zero_u32()
        {
            res = Self::from((Self::zero_u32() - self.underlying) * (Self::zero_u32() - other.underlying) + Self::zero_u32());
        } else if self.underlying >= Self::zero_u32()
            && other.underlying < Self::zero_u32()
        {
            res = Self::from(Self::zero_u32() - (self.underlying - Self::zero_u32()) * (Self::zero_u32() - other.underlying));
        } else if self.underlying < Self::zero_u32()
            && other.underlying >= Self::zero_u32()
        {
            res = Self::from(Self::zero_u32() - (other.underlying - Self::zero_u32()) * (Self::zero_u32() - self.underlying));
        }

        // Overflow protection
        require((res < Self::max()) || (res == Self::max()), I24Error::Overflow);

        res
    }
}

impl core::ops::Divide for I24 {
    /// Divide a I24 by a I24. Panics if divisor is zero.
    fn divide(self, divisor: Self) -> Self {
        require(divisor != Self::zero(), I24Error::DivisionByZero);
        let mut res = Self::zero();
        if self.underlying >= Self::zero_u32()
            && divisor.underlying > Self::zero_u32()
        {
            res = Self::from((self.underlying - Self::zero_u32()) / (divisor.underlying - Self::zero_u32()) + Self::zero_u32());
        } else if self.underlying < Self::zero_u32()
            && divisor.underlying < Self::zero_u32()
        {
            res = Self::from((Self::zero_u32() - self.underlying) / (Self::zero_u32() - divisor.underlying) + Self::zero_u32());
        } else if self.underlying >= Self::zero_u32()
            && divisor.underlying < Self::zero_u32()
        {
            res = Self::from(Self::zero_u32() - (self.underlying - Self::zero_u32()) / (Self::zero_u32() - divisor.underlying));
        } else if self.underlying < Self::zero_u32()
            && divisor.underlying > Self::zero_u32()
        {
            res = Self::from(Self::zero_u32() - (Self::zero_u32() - self.underlying) / (divisor.underlying - Self::zero_u32()));
        }
        res
    }
}

#[test]
fn i24_from_neg() {
}

#[test]
fn i24_from_uint() {
}

#[test]
fn i24_from_uint_bool() {
}

#[test]
fn i24_add() {
}

#[test]
fn i24_subtract() {
}

#[test]
fn i24_multiply() {
}

#[test]
fn i24_divide() {
}

#[test]
fn i24_mod() {
}

#[test]
fn i24_abs() {
}


