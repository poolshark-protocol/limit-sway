library;

use ::{
    types::{
        U128::*,
        Q64x64::*,
        Q128x128::*,
    },
    math::{
        full_math,
    },
};
    
pub fn handle_fees(
    output: u64,
    swap_fee: u32,
    current_liquidity: U128,
    total_fee_amount: u64,
    amount_out: u64,
    protocol_fee: u64,
    ref mut fee_growth_global: Q64x64,
) -> (u64, u64, u64, Q64x64) {
    let mut fee_amount = 0;
    let mut total_fee_amount = total_fee_amount;
    let mut amount_out = amount_out;
    let mut protocol_fee = protocol_fee;

    total_fee_amount = total_fee_amount + fee_amount;

    amount_out = amount_out + (output - fee_amount);

    let one_q128x128: Q128x128 = Q128x128::from_uint(1);
    let fee_amount: Q128x128 = Q128x128::from_uint(fee_amount);
    let current_liquidity: Q128x128 = Q128x128::from_u128(current_liquidity);

    fee_growth_global += mul_div_q64x64(fee_amount, one_q128x128, current_liquidity);

    return (
        total_fee_amount,
        amount_out,
        protocol_fee,
        fee_growth_global,
    );
}

#[test]
fn test_handle_fees() {
    
}
