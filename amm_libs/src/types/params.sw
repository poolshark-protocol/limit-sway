library;

use std::{
    bytes::*,
};

use ::types::{
    I24::*,
};

pub struct MintRangeParams {
    to: Identity,
    lower: I24,
    upper: I24,
    position_id: u32,
    amount0: u64,
    amount1: u64,
    callback_data: Bytes
}