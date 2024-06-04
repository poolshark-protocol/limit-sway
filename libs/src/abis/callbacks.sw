library;

use std::{
    bytes::*,
};

use ::types::{
    I64::*,
};

abi ILimitPoolMintRangeCallback {
    fn limit_pool_mint_range_callback(
        amount_0_delta: I64,
        amount_1_delta: I64,
        callback_data: Bytes,
    );
}