library;

use types::I24::*;

impl ConstantProduct {
    pub fn check_ticks(
        lower: I24,
        upper: I24,
        tick_spacing: u32,
    ) {
        let tick_spacing_i24: I24 = I24::from_uint(tick_spacing);
        require(lower >= min_tick(tick_spacing_i24), "INPUT ERROR: lower tick below minimum.");
        require(upper <= max_tick(tick_spacing_i24), "INPUT ERROR: upper tick above maximum.");
        require(lower % tick_spacing_i24 == 0, "INPUT ERROR: lower tick outside tick spacing.");
        require(upper % tick_spacing_i24 == 0, "INPUT ERROR: upper tick outside tick spacing.");
        require(lower >= upper, "INPUT ERROR: lower tick must be less than upper tick.");
    }
}