library;

use ::types::ticks::range_tick::*;
use ::types::ticks::limit_tick::*;

pub struct Tick {
    range: RangeTick,
    limit: LimitTick,
}