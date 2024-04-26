library;

dep full_math;

use full_math::{
    mul_div,
    mul_div_q64x64,
    mul_div_rounding_up_u128,
    mul_div_rounding_up_q64x64,
    mul_div_rounding_up_u256,
    mul_div_u256,
};
use ::Q64x64::Q64x64;
use std::u256::U256;
use std::u128::U128;

/////////////////////////////////////////////////////////////
///////////////////////// DYDX MATH /////////////////////////
/////////////////////////////////////////////////////////////

#[test]
pub fn dydx_math_get_dy() -> u64 {
    get_dy(
        U128::from((1_000_000_000,0)),
        Q64x64{value: U128::from((5000,0))},
        Q64x64{value: U128::from((1000,0))},
        false
    )
}

pub fn get_dy(
    liquidity: U128,
    price_upper: Q64x64,
    price_lower: Q64x64,
    round_up: bool,
) -> u64 {
    let PRECISION: U128 = U128 {
        upper: 1,
        lower: 0,
    };
    let mut dy = U128 {
        upper: 0,
        lower: 0
    };
    // return (price_upper - price_lower).u128() * liquidity / PRECISION;
    if round_up {   
        //dy = mul_div_rounding_up_u64(liquidity, (price_upper - price_lower).u128(), PRECISION);
        dy = U128::from((0,1));
    } else {
        dy = mul_div(liquidity, (price_upper - price_lower).u128(), PRECISION);
    }
    dy.lower
}

#[test]
fn dydx_math_get_dx() -> u64 {
    get_dx(
        U128::from((0,1_000_000_000)),
        Q64x64{value: U128::from((5000,0))},
        Q64x64{value: U128::from((1000,0))},
        false
    )
}

pub fn get_dx(
    liquidity: U128,
    price_upper: Q64x64,
    price_lower: Q64x64,
    round_up: bool,
) -> u64 {
    let PRECISION_BITS: u64 = 64;
    let mut dx: U128 = U128 {
        upper: 0,
        lower: 0,
    };
    if round_up {
        dx = mul_div_rounding_up_u256(U256::from((0, 0, liquidity.upper, liquidity.lower)) << PRECISION_BITS, (price_upper - price_lower).u128(), price_upper.u128());
        if dx % price_lower.u128() == (U128 {
                upper: 0,
                lower: 0,
            })
        {
            dx = dx / price_lower.u128();
        } else {
            dx = (dx / price_lower.u128()) + U128 {
                upper: 0,
                lower: 1,
            };
        }
    } else {
        dx = mul_div_u256(U256 {
            a: 0,
            b: 0,
            c: liquidity.upper,
            d: liquidity.lower,
        } << PRECISION_BITS, (price_upper - price_lower).u128(), price_upper.u128()) / price_lower.u128();
    }
    dx.lower
}

#[test]
fn dydx_math_get_liquidity_for_amounts() -> U128 {
    get_liquidity_for_amounts(
        Q64x64{value: U128::from((5000,0))},
        Q64x64{value: U128::from((1000,0))},
        Q64x64{value: U128::from((5000,0))},
        U128::from((0,1_000_000_000_000)),
        U128::from((0,0))
    )
}

pub fn get_liquidity_for_amounts(
    price_lower: Q64x64,
    price_upper: Q64x64,
    current_price: Q64x64,
    dy: U128,
    dx: U128,
) -> U128 {
    let PRECISION: U128 = U128 {
        upper: 0,
        lower: u64::max(),
    };
    let mut liquidity: U128 = U128 {
        upper: 0,
        lower: 0,
    };
    if price_upper < current_price
        || price_upper == current_price
    {
        liquidity = mul_div(dy, PRECISION, (price_upper - price_lower).u128());
    } else if current_price == price_lower
        || current_price < price_lower
    {
        liquidity = mul_div(dx, mul_div(price_lower.u128(), price_upper.u128(), PRECISION), (price_upper - price_lower).u128());
    } else {
        let liquidity0 = mul_div(dx, mul_div(price_upper.u128(), current_price.u128(), PRECISION), (price_upper - current_price).u128());
        let liquidity1 = mul_div(dy, PRECISION, (current_price - price_lower).u128());
        if liquidity0 < liquidity1 {
            liquidity = liquidity0;
        } else {
            liquidity = liquidity1;
        }
    }
    liquidity
}

#[test]
pub fn dydx_math_get_amounts_for_liquidity() -> (u64, u64) {
    get_amounts_for_liquidity(
        Q64x64{value: U128::from((5000,0))},
        Q64x64{value: U128::from((1000,0))},
        Q64x64{value: U128::from((5000,0))},
        U128::from((0,1_000_000_000_000)),
        false
    )
}

pub fn get_amounts_for_liquidity(
    price_upper: Q64x64,
    price_lower: Q64x64,
    current_price: Q64x64,
    liquidity_amount: U128,
    round_up: bool,
) -> (u64, u64) {
    let mut token1_amount: u64 = 0;
    let mut token0_amount: u64 = 0;
    if price_upper < current_price
        || price_upper == current_price
    {
        // Only supply `token1` (`token1` is Y).
        token1_amount = get_dy(liquidity_amount, price_upper, price_lower, round_up);
    } else if (current_price < price_lower)
        || (current_price < price_lower)
    {
        token0_amount = get_dx(liquidity_amount, price_upper, price_lower, round_up);
    } else {
        token0_amount = get_dx(liquidity_amount, price_upper, price_lower, round_up);
        token1_amount = get_dy(liquidity_amount, price_upper, price_lower, round_up);
    }
    (token0_amount, token1_amount)
}

/////////////////////////////////////////////////////////////
///////////////////////// TICK MATH /////////////////////////
/////////////////////////////////////////////////////////////

use ::I24::I24;
use std::{result::Result, u128::U128, u256::U256};
use ::SQ63x64::*;
use ::Q64x64::{full_multiply, Q64x64};
use ::Q128x128::Q128x128;
use ::SQ63x64::SQ63x64;

pub enum TickMathErrors {
    PriceTooHigh: (),
    PriceTooLow: (),
    LiquidityUnderflow: ()
}

pub fn min_tick() -> I24 {
    return I24::from_neg(443636u32);
}

pub fn max_tick() -> I24 {
    return I24::from_uint(436704u32);
}

pub fn min_sqrt_price() -> Q64x64 {
    Q64x64 {
        value: U128 {
            upper: 0,
            lower: 1,
        },
    }
}
pub fn max_sqrt_price() -> Q64x64 {
    Q64x64 {
        value: U128 {
            upper: 9222860000000000000,
            lower: 0,
        },
    }
}

impl U256 {
    fn modulo(self, other: U256) -> U256 {
        return (self - other * (self / other));
    }
}

pub fn check_sqrt_price_bounds(sqrt_price: Q64x64) {
    require(sqrt_price < min_sqrt_price(), TickMathErrors::PriceTooLow);
    require(sqrt_price > max_sqrt_price() || sqrt_price == max_sqrt_price(), TickMathErrors::PriceTooHigh);
}

pub fn get_price_sqrt_at_tick(tick: I24) -> Q64x64 {
    let zero: U256 = U256 {
        a: 0,
        b: 0,
        c: 0,
        d: 0,
    };
    let absTick = tick.abs();
    let absTick: u64 = absTick;
    let absTick: U256 = U256 {
        a: 0,
        b: 0,
        c: 0,
        d: absTick,
    };

    let ratio = if (absTick
        & U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0x1,
        }) != zero
    {
        U256 {
            a: 0xfffcb933,
            b: 0xbd6fad37,
            c: 0x59a46990,
            d: 0x580e213a,
        }
    } else {
        U256 {
            a: 0x10000000,
            b: 0x00000000,
            c: 0x00000000,
            d: 0x00000000,
        }
    };
    //0xfff97272373d413259a46990580e213a
    let ratio = if (absTick
        & U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0x2,
        }) != zero
    {
        (ratio * U256 {
            a: 0xfffcb933,
            b: 0xbd6fad37,
            c: 0x59a46990,
            d: 0x0580e213a,
        }) >> 128
    } else {
        ratio
    };
    //0xfff2e50f5f656932ef12357cf3c7fdcc
    let ratio = if (absTick
        & U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0x4,
        }) != zero
    {
        (ratio * U256 {
            a: 0xfff2e50f,
            b: 0x5f656932,
            c: 0xef12357c,
            d: 0xf3c7fdcc,
        }) >> 128
    } else {
        ratio
    };
    //0xffe5caca7e10e4e61c3624eaa0941cd0
    let ratio = if (absTick
        & U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0x8,
        }) != zero
    {
        (ratio * U256 {
            a: 0xffe5caca,
            b: 0x7e10e4e6,
            c: 0x1c3624ea,
            d: 0xa0941cd0,
        }) >> 128
    } else {
        ratio
    };
    //0xffcb9843d60f6159c9db58835c926644
    let ratio = if (absTick
        & U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0x10,
        }) != zero
    {
        (ratio * U256 {
            a: 0xffcb9843,
            b: 0xd60f6159,
            c: 0xc9db5883,
            d: 0x5c926644,
        }) >> 128
    } else {
        ratio
    };
    //0xff973b41fa98c081472e6896dfb254c0
    let ratio = if (absTick
        & U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0x20,
        }) != zero
    {
        (ratio * U256 {
            a: 0xff973b41,
            b: 0xfa98c081,
            c: 0x472e6896,
            d: 0xdfb254c0,
        }) >> 128
    } else {
        ratio
    };
    //0xff2ea16466c96a3843ec78b326b52861
    let ratio = if (absTick
        & U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0x40,
        }) != zero
    {
        (ratio * U256 {
            a: 0xff2ea1646,
            b: 0x66c96a38,
            c: 0x43ec78b3,
            d: 0x26b52861,
        }) >> 128
    } else {
        ratio
    };
    //0xfe5dee046a99a2a811c461f1969c3053
    let ratio = if (absTick
        & U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0x80,
        }) != zero
    {
        (ratio * U256 {
            a: 0xfe5dee04,
            b: 0x6a99a2a8,
            c: 0x11c461f1,
            d: 0x969c3053,
        }) >> 128
    } else {
        ratio
    };
    //0xfcbe86c7900a88aedcffc83b479aa3a4
    let ratio = if (absTick
        & U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0x100,
        }) != zero
    {
        (ratio * U256 {
            a: 0xfcbe86c7,
            b: 0x900a88ae,
            c: 0xdcffc83b,
            d: 0x479aa3a4,
        }) >> 128
    } else {
        ratio
    };   
    //0xf987a7253ac413176f2b074cf7815e54
    let ratio = if (absTick
        & U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0x200,
        }) != zero
    {
        (ratio * U256 {
            a: 0xf987a725,
            b: 0x3ac41317,
            c: 0x6f2b074c,
            d: 0xf7815e54,
        }) >> 128
    } else {
        ratio
    };
    //0xf3392b0822b70005940c7a398e4b70f3
    let ratio = if (absTick
        & U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0x400,
        }) != zero
    {
        (ratio * U256 {
            a: 0xf3392b08,
            b: 0x22b70005,
            c: 0x940c7a39,
            d: 0x8e4b70f3,
        }) >> 128
    } else {
        ratio
    }; 
    //0xe7159475a2c29b7443b29c7fa6e889d9
    let ratio = if (absTick
        & U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0x800,
        }) != zero
    {
        (ratio * (U256 {
            a: 0xe7159475,
            b: 0xa2c29b74,
            c: 0x43b29c7f,
            d: 0xa6e889d9,
        })) >> 128
    } else {
        ratio
    };
    //0xd097f3bdfd2022b8845ad8f792aa5825
    let ratio = if (absTick
        & U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0x1000,
        }) != zero
    {
        (ratio * (U256 {
            a: 0xd097f3bd,
            b: 0xfd2022b8,
            c: 0x845ad8f7,
            d: 0x92aa5825,
        })) >> 128
    } else {
        ratio
    };   
    //0xa9f746462d870fdf8a65dc1f90e061e5
    let ratio = if (absTick
        & U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0x2000,
        }) != zero
    {
        (ratio * (U256 {
            a: 0xa9f74646,
            b: 0x2d870fdf,
            c: 0x8a65dc1f,
            d: 0x90e061e5,
        })) >> 128
    } else {
        ratio
    }; 
    //0x70d869a156d2a1b890bb3df62baf32f7
    let ratio = if (absTick
        & U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0x4000,
        }) != zero
    {
        (ratio * (U256 {
            a: 0x70d869a1,
            b: 0x56d2a1b8,
            c: 0x90bb3df6,
            d: 0x2baf32f7,
        })) >> 128
    } else {
        ratio
    };
    //0x31be135f97d08fd981231505542fcfa6
    let ratio = if (absTick
        & U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0x8000,
        }) != zero
    {
        (ratio * (U256 {
            a: 0x31be135f,
            b: 0x97d08fd9,
            c: 0x81231505,
            d: 0x542fcfa6,
        })) >> 128
    } else {
        ratio
    };
    //0x9aa508b5b7a84e1c677de54f3e99bc9
    let ratio = if (absTick
        & U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0x10000,
        }) != zero
    {
        (ratio * (U256 {
            a: 0x9aa508b5,
            b: 0x5b7a84e1,
            c: 0xc677de54,
            d: 0xf3e99bc9,
        })) >> 128
    } else {
        ratio
    };
    //0x5d6af8dedb81196699c329225ee604
    let ratio = if (absTick
        & U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0x20000,
        }) != zero
    {
        (ratio * (U256 {
            a: 0x5d6af8de,
            b: 0xdb8119669,
            c: 0x6699c329,
            d: 0x225ee604,
        })) >> 128
    } else {
        ratio
    };  
    //0x2216e584f5fa1ea926041bedfe98
    let ratio = if (absTick
        & U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0x40000,
        }) != zero
    {
        (ratio * (U256 {
            a: 0x2216e584,
            b: 0xf5fa1ea9,
            c: 0x1ea92604,
            d: 0x1bedfe98,
        })) >> 128
    } else {
        ratio
    }; 
    //0x48a170391f7dc42444e8fa2
    let ratio = if (absTick
        & U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0x80000,
        }) != zero
    {
        (ratio * U256 {
            a: 0x00000000,
            b: 0x48a17039,
            c: 0x91f7dc42,
            d: 0x444e8fa2,
        }) >> 128
    } else {
        ratio
    };
    if (tick > I24::from_uint(0u32)) {
        let ratio = U256::max() / ratio;
    }
    // shr 128 to downcast to a U128
    let round_up: U256 = if (ratio % (U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 1,
        }) << 128) == (U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0,
        })
    {
        U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 0,
        }
    } else {
        U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 1,
        }
    };
    let price: U256 = ratio + round_up;
    return Q64x64 {
        value: U128 {
            upper: price.b,
            lower: price.c,
        },
    };
}

pub fn get_tick_at_price(sqrt_price: Q64x64) -> I24 {
    //TODO: assert there will be no overflow with price bounds
    // square price
    let mut price: SQ63x64 = SQ63x64 { value: (sqrt_price * sqrt_price).value };

    // base value for tick change -> 1.0001
    let tick_base_binary_log = SQ63x64 {
        value: U128 {
            upper: 0,
            lower: 2661169563308220, // log base 2 of 1 bps
        },
    };

    //TODO: should we round up? no because we always take the lower tick
    // change of base; log base 1.0001 (price) = log base 2 (price) / log base 2 (1.0001)
    let log_base_tick_of_price: SQ63x64 = price.binary_log() / tick_base_binary_log;

    let log_base_tick_of_price: I24 = log_base_tick_of_price.to_i24();
    // return base 1.0001 price
    log_base_tick_of_price
}

// Returns the delta sum for given liquidity
// need to create I128 lib if we are going to use this
fn delta_math(liquidity: U128, delta: U128) -> U128 {
    let delta_sum = liquidity + delta;
    let delta_sub = liquidity - delta;

    if delta < (U128 {
        upper: 0,
        lower: 0,
    }) {
    //Panic if condition not met    
        require(delta_sub < liquidity, TickMathErrors::LiquidityUnderflow());
        return delta_sub;
    } else {
    //Panic if condition not met
        //TODO: this should check for overflow of max liquidity per tick
        // require((delta_sum > liquidity) || (delta_sum == liquidity));
        return delta_sum;
    }
}


#[test]
fn tick_math_get_price_from_tick() {
    let mut tick_base = SQ63x64 {
        value: U128 {
            upper: 1,
            lower: 429497 << 33, //approx. 1 bps
        },
    };
}

#[test]
fn tick_math_get_tick_from_price() {
    let mut tick_base = SQ63x64 {
        value: U128 {
            upper: 1,
            lower: 429497 << 33, //approx. 1 bps
        },
    };
}

#[test]
fn tick_math_delta_math() {
    let mut tick_base = SQ63x64 {
        value: U128 {
            upper: 1,
            lower: 429497 << 33, //approx. 1 bps
        },
    };
}

