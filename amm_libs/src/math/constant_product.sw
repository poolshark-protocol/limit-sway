library;

use ::types::I24::*;

struct ConstantProduct {}

// @dev - tick for price of 2^-128
const MIN_TICK: I24 = I24::from_neg(887272);
// @dev - tick for price of 2^128
const MAX_TICK: I24 = -MIN_TICK;

impl ConstantProduct {
    pub fn check_ticks(
        lower: I24,
        upper: I24,
        tick_spacing: u32,
    ) {
        let tick_spacing_i24: I24 = I24::from_uint(tick_spacing);
        require(lower.ge(min_tick(tick_spacing_i24)), "INPUT ERROR: lower tick below minimum.");
        require(upper.lt(max_tick(tick_spacing_i24)), "INPUT ERROR: upper tick above maximum.");
        require(lower % tick_spacing_i24 == 0, "INPUT ERROR: lower tick outside tick spacing.");
        require(upper % tick_spacing_i24 == 0, "INPUT ERROR: upper tick outside tick spacing.");
        require(lower >= upper, "INPUT ERROR: lower tick must be less than upper tick.");
    }

    pub fn min_tick(
        tick_spacing: u32
    ) -> I24 {
        MIN_TICK
            / I24::from_uint(tick_spacing)
            * I24::from_uint(tick_spacing)
    }

    pub fn max_tick(
        tick_spacing: u32
    ) -> I24 {
        MAX_TICK
            / I24::from_uint(tick_spacing)
            * I24::from_uint(tick_spacing)
    }
}