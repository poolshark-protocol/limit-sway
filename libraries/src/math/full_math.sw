library;

use ::math::types::Q64x64::Q64x64;
use ::math::types::Q128x128::Q128x128;
use std::{result::Result, u128::U128, u256::U256};
use std::revert::revert;

pub enum FullMathError {
    Overflow: (),
    DivisionByZero: (),
}

fn log2(number: u64) -> u64 {
    let two = 2;
    asm(r1: number, r2: 2, r3) {
        mlog r3 r1 r2;
        r3: u64
    }
}

#[test]
pub fn test_log2() -> (u64) {
    let result = log2(9);
    assert(result == 3);
    result
}

pub fn msb_idx(input: U256) -> u32 {
    let mut msb_idx: u32 = 0;
    if input.a > 0 {
        msb_idx += 192;
        msb_idx += log2(input.a);
    } else if input.b > 0 {
        msb_idx += 128;
        msb_idx += log2(input.b);
    } else if input.c > 0 {
        msb_idx += 64;
        msb_idx += log2(input.c);
    } else {
        msb_idx += log2(input.d);
    }
    msb_idx
}

#[test]
pub fn test_msb_idx() -> (u64) {
    let result = msb_idx(U256::from((0,0,0,2)));
    assert(result == 2);
    result
}

pub fn mul_div(base: U128, factor: U128, denominator: U128) -> U128 {
    let base_u256 = U256 {
        a: 0,
        b: 0,
        c: base.upper,
        d: base.lower,
    };
    let factor_u256 = U256 {
        a: 0,
        b: 0,
        c: factor.upper,
        d: factor.lower,
    };
    let denominator_u256 = U256::from((
        0,
        0,
        denominator.upper,
        denominator.lower,
    ));
    //TODO: this division does not work properly
    let res_u256 = (base_u256 * factor_u256 / denominator_u256);
    //TODO:
    // if (res_u256.a != 0) || (res_u256.b != 0) {
    //     // panic on overflow
    //     revert(0);
    // }

    U128 {
        upper: res_u256.c,
        lower: res_u256.d,
    }
}
pub fn mul_div_u64(base: u64, factor: u64, denominator: u64) -> u64 {
    let base = U128 {
        upper: 0,
        lower: base,
    };
    let factor = U128 {
        upper: 0,
        lower: factor,
    };
    let denominator = U128 {
        upper: 0,
        lower: denominator,
    };
    let res = (base * factor) / (denominator);
    if res.upper != 0 {
        // panic on overflow
        revert(0);
    }
    res.lower
}

#[test]
pub fn test_mul_div_u64() -> (u64) {
    let result = mul_div_u64(9, 6, 6);
    assert(result == 9);
    result
}

pub fn mul_div_rounding_up_u64(base: u64, factor: u64, denominator: u64) -> u64 {
    let base = U128 {
        upper: 0,
        lower: base,
    };
    let factor = U128 {
        upper: 0,
        lower: factor,
    };
    let denominator = U128 {
        upper: 0,
        lower: denominator,
    };
    let mut res = (base * factor) / denominator;

    if (res * denominator) != (factor * base) {
        res += U128 {
            upper: 0,
            lower: 1,
        };
    }
    if res.upper != 0 {
        // panic on overflow
        revert(0);
    }

    let result: u64 = res.lower;

    result
}

#[test]
pub fn test_mul_div_rounding_up_u64() -> (u64) {
    let result = mul_div_rounding_up_u64(3, 1, 2);
    assert(result == 2);
    result
}

pub fn mul_div_rounding_up_u128(base: U128, factor: U128, denominator: U128) -> U128 {
    let base_u256 = U256 {
        a: 0,
        b: 0,
        c: base.upper,
        d: base.lower,
    };
    let factor_u256 = U256 {
        a: 0,
        b: 0,
        c: factor.upper,
        d: factor.lower,
    };
    let denominator_u256 = U256 {
        a: 0,
        b: 0,
        c: denominator.upper,
        d: denominator.lower,
    };
    let mut res_u256 = base_u256 * factor_u256 / denominator_u256;
    if (res_u256 * denominator_u256) != (base_u256 * factor_u256) {
        res_u256 = res_u256 + U256 {
            a: 0,
            b: 0,
            c: 0,
            d: 1,
        };
    }
    if (res_u256.a != 0) || (res_u256.b != 0) {
        // panic on overflow
        revert(0);
    }
    U128 {
        upper: res_u256.c,
        lower: res_u256.d,
    }
}

#[test]
pub fn test_mul_div_rounding_up_u128() -> (U128) {
    let result = mul_div_rounding_up_u128(U128::from((0,3)), U128::from((0,2)), U128::from((0,4)));
    assert(result == U128::from((0,2)));
    result
}

pub fn mul_div_u256(base: U256, factor: U128, denominator: U128) -> U128 {
    let base_u256 = base;
    let factor_u256 = U256 {
        a: 0,
        b: 0,
        c: factor.upper,
        d: factor.lower,
    };
    let denominator_u256 = U256 {
        a: 0,
        b: 0,
        c: denominator.upper,
        d: denominator.lower,
    };
    let res_u256 = base_u256 * factor_u256 / denominator_u256;
    if (res_u256.a != 0) || (res_u256.b != 0) {
        // panic on overflow
        revert(0);
    }
    return U128 {
        upper: res_u256.c,
        lower: res_u256.d,
    };
}

#[test]
pub fn test_mul_div_u256() -> (U128) {
    let result = mul_div_u256(U256::from((0,3)), U128::from((0,2)), U128::from((0,4)));
    assert(result == U128::from((0,2)));
    result
}

pub fn mul_div_rounding_up_u256(base: U256, factor: U128, denominator: U128) -> U128 {
    let base_u256 = base;
    let factor_u256 = U256 {
        a: 0,
        b: 0,
        c: factor.upper,
        d: factor.lower,
    };
    let denominator_u256 = U256 {
        a: 0,
        b: 0,
        c: denominator.upper,
        d: denominator.lower,
    };
    let res_u256 = base_u256 * factor_u256 / denominator_u256;
    if (res_u256.a != 0) || (res_u256.b != 0) {
        // panic on overflow
        revert(0);
    }
    let mut res_128 = U128 {
        upper: res_u256.c,
        lower: res_u256.d,
    };
    if res_u256 * denominator_u256 != base_u256 * factor_u256 {
        res_128 = res_128 + U128 {
            upper: 0,
            lower: 1,
        };
    }

    res_128
}

#[test]
pub fn test_mul_div_rounding_up_u256() -> (U128) {
    let result = mul_div_rounding_up_u256(U256::from((0,3)), U128::from((0,2)), U128::from((0,4)));
    assert(result == U128::from((0,2)));
    result
}

pub fn mul_div_q64x64(base: Q128x128, factor: Q128x128, denominator: Q128x128) -> Q64x64 {
    let mut res: Q128x128 = (base * factor) / denominator;
    if (res.value.a != 0) || (res.value.b != 0) {
        // panic on overflow
        revert(0);
    }
    Q64x64 {
        value: U128 {
            upper: res.value.b,
            lower: res.value.c,
        },
    }
}

// #[test]
// pub fn test_mul_div_q64x64() -> (Q64x64) {
//     let result = mul_div_rounding_up_u256(Q128{value: U256::from((0,3))}, Q128{U128::from((0,2))}, Q128{U128::from((0,4))});
//     assert(result.value == U256::from((0,0,0,1)));
//     result
// }

pub fn mul_div_rounding_up_q64x64(
    base: Q128x128,
    factor: Q128x128,
    denominator: Q128x128,
) -> Q64x64 {
    let mut res: Q128x128 = (base * factor) / denominator;
    if res * denominator != base * factor {
        res = res + Q128x128 {
            value: U256 {
                a: 0,
                b: 0,
                c: 0,
                d: 1,
            },
        };
    }
    if (res.value.a != 0) || (res.value.b != 0) {
        // panic on overflow
        revert(0);
    }
    Q64x64 {
        value: U128 {
            upper: res.value.b,
            lower: res.value.c,
        },
    }
}

#[test]
pub fn test_mul_div_rounding_up_q64x64() -> (Q64x64) {
    let result = image.png(Q128x128{value: U256::from((0,3))}, Q128x128{value: U128::from((0,2))}, Q128x128{value: U128::from((0,4))});
    assert(result.value == U256::from((0,0,0,2)));
    result
}