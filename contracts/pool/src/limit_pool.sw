contract;

pub mod errors;

use ::errors::ConcentratedLiquidityPoolErrors;

use std::{
    revert::require,
    identity::*,
    contract_id::*,
    asset_id::*,
    address::Address,
    u128::*,
    u256::*,
    asset::transfer,
    result::*,
    auth::*,
    hash::*,
    logging::log,
    call_frames::{contract_id ,msg_asset_id},
    context::msg_amount,
    alias::SubId,
    storage::storage_vec::*
};

use amm_libs::{
    types::{
        I24::*,
        I64::*,
        Q64x64::*,
        Q128x128::*,
        state::{
            global_state::*,
        },
        ticks::{
            tick_map::*,
        },
        positions::{
            range_position::*,
        },
        params::*,
        events::*,
        cache::*,
    },
    math::{
        dydx_math::*,
        tick_math::*,
        full_math::*,
    },
    range::{
        pool::{
            mint_range_call::*,
        },
    },
};

impl core::ops::Ord for AssetId {
    fn lt(self, other: Self) -> bool {
        self.value < other.value
    }
    fn gt(self, other: Self) -> bool {
        self.value > other.value
    }
}

impl u64 {
    fn as_u128(self) -> U128 {
        U128 {
            upper: 0,
            lower: self
        }
    }
}

impl SubId {
    fn default() -> SubId {
        let default_sub_id: SubId = 0x0000000000000000000000000000000000000000000000000000000000000000;
        default_sub_id
    }
}

struct Position {
    liquidity: U128,
    fee_growth_inside0: Q64x64,
    fee_growth_inside1: Q64x64,
}

struct Tick {
    prev_tick: I24, 
    next_tick: I24,
    liquidity: U128,
    fee_growth_outside0: Q64x64,
    fee_growth_outside1: Q64x64,
    seconds_growth_outside: U128
}

abi ConcentratedLiquidityPool {
    // Core functions
    #[storage(read, write)]
    fn initialize(start_price: Q64x64);

    // alphak3y
    #[storage(read, write)]
    fn mint_range(params: MintRangeParams) -> (I64, I64);

    // // alphak3y
    // #[storage(read, write)]
    // fn burn_range(params: BurnRangeParams) -> (I64, I64);

    // // alphak3y
    // #[storage(read, write)]
    // fn mint_limit(params: MintLimitParams) -> (I64, I64);

    // // alphak3y
    // #[storage(read, write)]
    // fn burn_limit(params: BurnLimitParams) -> (I64, I64);

    // // alphak3y
    // #[storage(read, write)]
    // fn swap(params: SwapParams) -> (I64, I64);

    // #[storage(read, write)]
    // fn increase_sample_count(new_sample_count: u16);

    // // alphak3y
    // #[storage(read, write)]
    // fn fees(params: FeeParams) -> (U128, U128);

    // // alphak3y
    // #[storage(read, write)]
    // fn quote(params: QuoteParams) -> (u64, u64, Q64x64);

    // // alphak3y
    // #[storage(read, write)]
    // fn sample(secondsAgo: Vec<u32>) -> (Vec<I24>, Vec<U128>, Q64x64, U128, I24);

    // // alphak3y
    // #[storage(read)]
    // fn snapshot_range(positionId: u32) -> (I24, Q64x64, u64, u64);

    // #[storage(read, write)]
    // fn snapshot_limit(params: SnapshotLimitParams) -> (u64, u64);
}

// Should be all storage variables
storage {
    token0: AssetId = AssetId{ value: 0x0000000000000000000000000000000000000000000000000000000000000000 },
    token1: AssetId = AssetId{ value: 0x0000000000000000000000000000000000000000000000000000000000000000 },

    unlocked: bool = false,

    tick_spacing: u8 = 10u8,

    ticks: StorageMap<I24, Tick> = StorageMap::<I24, Tick> {},
    positions: StorageMap<u32, RangePosition> = StorageMap::<u32, RangePosition> {},

    range_tick_map: TickMap = TickMap {
        blocks: 0u64,
        words: StorageMap::<u256, u256> {},
        ticks: StorageMap::<u256, u256> {},
        epochs0: StorageMap::<u256, StorageMap<u256, StorageMap<u256, u256>>> {},
        epochs1: StorageMap::<u256, StorageMap<u256, StorageMap<u256, u256>>> {},
    },

    limit_tick_map: TickMap = TickMap {
        blocks: 0u64,
        words: StorageMap::<u256, u256> {},
        ticks: StorageMap::<u256, u256> {},
        epochs0: StorageMap::<u256, StorageMap<u256, StorageMap<u256, u256>>> {},
        epochs1: StorageMap::<u256, StorageMap<u256, StorageMap<u256, u256>>> {},
    },

    samples: StorageVec<Sample> = StorageVec {},

    global_state: GlobalState = GlobalState::new(),
}

impl ConcentratedLiquidityPool for Contract {
    #[storage(read, write)]
    fn initialize(start_price: Q64x64) {

        log(InitPoolEvent {
            pool_id: contract_id().into(),
            min_tick: I24::zero(),
            max_tick: I24::zero(),
            start_price: Q64x64::zero(),
            start_tick: I24::zero(),
        });
    }

    #[storage(read, write)]
    fn mint_range(params: MintRangeParams) -> (I64, I64) {

        let mut state: GlobalState = storage.global_state.read();

        let range_tick_map_keys = TickMapKeys {
            blocks: storage.range_tick_map.blocks,
            words: storage.range_tick_map.words,
            ticks: storage.range_tick_map.ticks,
            epochs0: storage.range_tick_map.epochs0,
            epochs1: storage.range_tick_map.epochs1,
        };

        let result = MintRangeCall::perform(
            storage.positions,
            storage.ticks,
            range_tick_map_keys,
            storage.samples,
            storage.global_state,
            MintRangeCache::new(),
            params,
        );

        log(MintRangeEvent {
            pool_id: contract_id().into(),
            recipient: params.to,
            lower: params.lower,
            upper: params.upper,
            position_id: state.position_id_next,
            liquidity_minted: 1u64,
            amount_0_delta: I64::from_uint(1u64),
            amount_1_delta: I64::from_uint(1u64),
        });

        state.position_id_next = state.position_id_next + 1;

        storage.global_state.write(state);

        (I64::zero(), I64::zero())
    }

    // #[storage(read, write)]
    // fn burn_range(params: BurnRangeParams) -> (I64, I64) {

    //     log(BurnRangeEvent {
    //         pool: contract_id(),
    //         token0: storage.token0.read(),
    //         token1: storage.token1.read(),
    //         swap_fee: storage.global_state.pool.swap_fee.read(),
    //         tick_spacing: storage.tick_spacing.read(),
    //         start_price,
    //         start_tick: get_tick_at_price(start_price),
    //     });

    //     (I64::zero(), I64::zero())
    // }

    // #[storage(read, write)]
    // fn mint_limit(params: MintLimitParams) -> (I64, I64) {

    //     log(MintLimitEvent {
    //         pool: contract_id(),
    //         token0: storage.token0.read(),
    //         token1: storage.token1.read(),
    //         swap_fee: storage.global_state.pool.swap_fee.read(),
    //         tick_spacing: storage.tick_spacing.read(),
    //         start_price,
    //         start_tick: get_tick_at_price(start_price),
    //     });

    //     (I64::zero(), I64::zero())
    // }

    // #[storage(read, write)]
    // fn burn_limit(params: BurnLimitParams) -> (I64, I64) {

    //     log(BurnLimitEvent {
    //         pool: contract_id(),
    //         token0: storage.token0.read(),
    //         token1: storage.token1.read(),
    //         swap_fee: storage.global_state.pool.swap_fee.read(),
    //         tick_spacing: storage.tick_spacing.read(),
    //         start_price,
    //         start_tick: get_tick_at_price(start_price),
    //     });

    //     (I64::zero(), I64::zero())
    // }

    // #[storage(read, write)]
    // fn swap(params: SwapParams) -> (I64, I64) {

    //     log(SwapEvent {
    //         pool: contract_id(),
    //         token0: storage.token0.read(),
    //         token1: storage.token1.read(),
    //         swap_fee: storage.global_state.pool.swap_fee.read(),
    //         tick_spacing: storage.tick_spacing.read(),
    //         start_price,
    //         start_tick: get_tick_at_price(start_price),
    //     });

    //     (I64::zero(), I64::zero())
    // }

    // #[storage(read, write)]
    // fn increase_sample_count(new_sample_count_max: u16) {

    //     log(SwapEvent {
    //         pool: contract_id(),
    //         token0: storage.token0.read(),
    //         token1: storage.token1.read(),
    //         swap_fee: storage.global_state.pool.swap_fee.read(),
    //         tick_spacing: storage.tick_spacing.read(),
    //         start_price,
    //         start_tick: get_tick_at_price(start_price),
    //     });

    //     (I64::zero(), I64::zero())
    // }

    // #[storage(read, write)]
    // fn fees(params: FeesParams) -> (u64, u64) {

    //     (I64::zero(), I64::zero())
    // }


//     #[storage(read)]
//     fn quote_amount_in(token_zero_to_one: bool, amount_out: u64) -> u64 {
//         let zero_u128        = U128{upper: 0, lower: 0};
//         let one_u128         = U128{upper: 0, lower: 1};
//         let one_e_6_u128     = U128{upper: 0, lower: 1000000};
//         let one_q128x128     = Q128x128::from_uint(1);
//         let one_e_6_q128x128 = Q128x128::from_u128(one_e_6_u128);

//         let swap_fee = U128{upper: 0, lower: storage.swap_fee};
//         let mut amount_out_no_fee = ((U128{upper: 0, lower: amount_out}) * one_e_6_u128) / (one_e_6_u128 - swap_fee) + one_u128;
//         let mut current_price = storage.sqrt_price;
//         let mut current_liquidity = storage.liquidity;
//         let mut next_tick_to_cross = if token_zero_to_one { storage.nearest_tick.read() } else { storage.ticks.get(storage.nearest_tick).next_tick };
//         let mut next_tick: I24 = I24::zero();
//         let tick_spacing = storage.tick_spacing;

//         let mut final_amount_in: U128 = U128{upper: 0, lower: 0};
//         let mut final_amount_out: U128 = U128{upper: 0, lower: amount_out};

//         while amount_out_no_fee != zero_u128 {
//             let mut next_tick_price = get_price_at_tick(next_tick_to_cross);
//             if token_zero_to_one {
//                 let mut max_dy = get_dy(current_liquidity, next_tick_price, current_price, false).u128();
//                 if amount_out_no_fee < max_dy || amount_out_no_fee == max_dy {
//                     final_amount_out = (final_amount_out * one_e_6_u128) / (one_e_6_u128 - swap_fee) + one_u128;
//                     let liquidity_padded  = Q128x128::from_u128(current_liquidity);
//                     let price_padded      = Q128x128::from_q64x64(current_price.value);
//                     let amount_out_padded = Q128x128::from_u128(final_amount_out);
//                     let new_price = current_price - mul_div_rounding_up_q64x64(amount_out_padded, Q128x128::from_uint(u64::max()), liquidity_padded);
//                     final_amount_in += get_dx(current_liquidity, new_price, current_price, false).u128() + one_u128;
//                     break;
//                 } else {
//                     if next_tick_to_cross / I24::from_uint(tick_spacing) % I24::from_uint(2) == I24::zero(){
//                         current_liquidity -= storage.ticks.get(next_tick_to_cross).liquidity;
//                     } else {
//                         current_liquidity += storage.ticks.get(next_tick_to_cross).liquidity;
//                     }
//                     amount_out_no_fee -= max_dy - one_u128; // handle rounding issues
//                     let fee_amount = mul_div_rounding_up(max_dy, swap_fee, one_e_6_u128);
//                     if final_amount_out < (max_dy - swap_fee) || final_amount_out == (max_dy - swap_fee) {
//                         break;
//                     }
//                     final_amount_out -= (max_dy - fee_amount);
//                     next_tick = storage.ticks.get(next_tick_to_cross).prev_tick;
//                 }
                
//             } else {
//                 let max_dx = get_dx(current_liquidity, current_price, next_tick_price, false).u128();
//                 if amount_out_no_fee < max_dx || amount_out_no_fee == max_dx {
//                     final_amount_out = (final_amount_out * one_e_6_u128) / (one_e_6_u128 - swap_fee) + one_u128;

//                     let liquidity_padded  = Q128x128::from_u128(current_liquidity);
//                     let price_padded      = Q128x128::from_q64x64(current_price.value);
//                     let amount_out_padded = Q128x128::from_u128(final_amount_out);
//                     let mut new_price : Q64x64 = mul_div_rounding_up_q64x64(liquidity_padded, price_padded, liquidity_padded - price_padded * amount_out_padded);

//                     if !(current_price < new_price && (new_price < next_tick_price || new_price == next_tick_price)) {
//                         new_price = mul_div_rounding_up_q64x64(one_q128x128, liquidity_padded, liquidity_padded / price_padded - amount_out_padded);
//                     }
//                     final_amount_in += get_dy(current_liquidity, current_price, new_price, false).u128() + one_u128;
//                     break;
//                 } else {
//                     final_amount_in += get_dy(current_liquidity, current_price, next_tick_price, false).u128();
//                     if next_tick_to_cross / I24::from_uint(tick_spacing) % I24::from_uint(2) == I24::zero(){
//                         current_liquidity += storage.ticks.get(next_tick_to_cross).liquidity;
//                     } else {
//                         current_liquidity -= storage.ticks.get(next_tick_to_cross).liquidity;
//                     }
//                     amount_out_no_fee -= max_dx + one_u128; // resolve rounding errors
//                     let fee_amount = mul_div_rounding_up(max_dx, swap_fee, one_e_6_u128);
//                     if final_amount_out < (max_dx - fee_amount) || final_amount_out == (max_dx - fee_amount){
//                         break;
//                     }
//                     final_amount_out -= (max_dx - fee_amount);
//                     next_tick = storage.ticks.get(next_tick_to_cross).next_tick;
//                 }
//             }
//             current_price = next_tick_price;
//             if(next_tick_to_cross != next_tick) break;
//             next_tick_to_cross = next_tick;
//         }
         
//         final_amount_in.lower
//     }

//     #[storage(read, write)]
//     fn mint(lower_old: I24, lower: I24, upper_old: I24, upper: I24, amount0_desired: u64, amount1_desired: u64, recipient: Identity) -> U128 {
//         _ensure_tick_spacing(upper, lower).unwrap();

//         let price_lower = get_price_at_tick(lower);
//         let price_upper = get_price_at_tick(upper);
//         let current_price = storage.sqrt_price;

//         let liquidity_minted = get_liquidity_for_amounts(price_lower, price_upper, current_price, U128{upper: 0, lower: amount1_desired}, U128{upper: 0, lower: amount0_desired});

//         // _updateSecondsPerLiquidity(uint256(liquidity));

//         let (amount0_fees, amount1_fees) = _update_position(recipient, lower, upper, liquidity_minted, true);

//         let sender: Identity= msg_sender().unwrap();

//         if amount0_fees > 0 {
//             transfer(amount0_fees, storage.token0, sender);
//             storage.reserve0 -= amount0_fees;
//         }
//         if amount1_fees > 0 {
//             transfer(amount1_fees, storage.token1, sender);
//             storage.reserve1 -= amount1_fees;
//         }
//         if (price_lower < current_price || price_lower == current_price) && (current_price < price_upper) {
//             storage.liquidity += liquidity_minted;
//         }

//         storage.nearest_tick.read() = tick_insert(
//             liquidity_minted,
//             upper, lower,
//             upper_old, lower_old
//         );

//         let (amount0_actual, amount1_actual) = get_amounts_for_liquidity(price_upper, price_lower, current_price, liquidity_minted, true);

//         //IPositionManager(msg.sender).mintCallback(token0, token1, amount0Actual, amount1Actual, mintParams.native);
//         _position_update_reserves(true, amount0_actual, amount1_actual);

//         let sender: Identity= msg_sender().unwrap();

//         log(MintEvent {
//             pool: contract_id(),
//             sender,
//             recipient,
//             token0_amount: amount0_desired,
//             token1_amount: amount1_desired,
//             liquidity_minted,
//             tick_lower:lower,
//             tick_upper:upper,
//         });

//         liquidity_minted
//     }

//     #[storage(read, write)]
//     fn burn(recipient: Identity, lower: I24, upper: I24, liquidity_amount: U128) -> (u64, u64, u64, u64) {

//         // get prices
//         let price_lower = get_price_at_tick(lower);
//         let price_upper = get_price_at_tick(upper);
//         let current_price = storage.sqrt_price;

//         // _updateSecondsPerLiquidity(uint256(liquidity));

//         // if the liquidity is in range subtract from current liquidity
//         if ((current_price > price_lower) || (current_price == price_lower)) && current_price < price_upper {
//             storage.liquidity -= liquidity_amount;
//         }

//         let sender: Identity= msg_sender().unwrap();

//         let (amount0_fees, amount1_fees) = _update_position(sender, lower, upper, liquidity_amount, false);

//         let (token0_amount, token1_amount) = get_amounts_for_liquidity(price_upper, price_lower, current_price, liquidity_amount, false);

//         let amount0:u64 = token0_amount + amount0_fees;
//         let amount1:u64 = token1_amount + amount1_fees;

//         _position_update_reserves(false, amount0, amount1);

//         transfer(amount0, storage.token0, sender);
//         transfer(amount1, storage.token1, sender);

//         log(BurnEvent {
//             pool: contract_id(),
//             sender,
//             token0_amount,
//             token1_amount,
//             liquidity_burned: liquidity_amount,
//             tick_lower:lower,
//             tick_upper:upper,
//         });

//         let mut nearest_tick = storage.nearest_tick;
//         storage.nearest_tick.read() = tick_remove(lower, upper, liquidity_amount, nearest_tick);
        
//         (token0_amount, token1_amount, amount0_fees, amount1_fees)
//     }

//     #[storage(read, write)]
//     fn collect(tick_lower: I24, tick_upper: I24) -> (u64, u64) {
//         let sender: Identity= msg_sender().unwrap();
//         let (amount0_fees, amount1_fees) = _update_position(sender, tick_lower, tick_upper, (U128{upper: 0, lower:0}), false);

//         storage.reserve0 -= amount0_fees;
//         storage.reserve1 -= amount1_fees;

//         transfer(amount0_fees, storage.token0, sender);
//         transfer(amount1_fees, storage.token1, sender);

//         (amount0_fees, amount1_fees)
//     }
}
// #[storage(read)]
// fn _ensure_tick_spacing(upper: I24, lower: I24) -> Result<(), ConcentratedLiquidityPoolErrors> {
//     if lower % I24::from_uint(storage.tick_spacing) != I24::from_uint(0) {
//         return Result::Err(ConcentratedLiquidityPoolErrors::InvalidTick);
//     }
//     if (lower / I24::from_uint(storage.tick_spacing)) % I24::from_uint(2) != I24::from_uint(0) {
//         return Result::Err(ConcentratedLiquidityPoolErrors::LowerEven);
//     }
//     if upper % I24::from_uint(storage.tick_spacing) != I24::from_uint(0) {
//         return Result::Err(ConcentratedLiquidityPoolErrors::InvalidTick);
//     }
//     if (upper / I24::from_uint(storage.tick_spacing)) % I24::from_uint(2) == I24::from_uint(0) {
//         return Result::Err(ConcentratedLiquidityPoolErrors::UpperOdd);
//     }

//     Result::Ok(())
// }

// #[storage(read, write)]
// fn _update_position(owner: Identity, lower: I24, upper: I24, amount: U128, add_liquidity: bool) -> (u64, u64) {
//     let mut position = storage.positions.get((owner, lower, upper));
//     require(add_liquidity || (amount < position.liquidity || amount == position.liquidity), FullMathError::Overflow);
//     let (range_fee_growth0, range_fee_growth1) = range_fee_growth(lower, upper);
    
//     let amount0_fees = 
//         Q128x128::from_q64x64((range_fee_growth0 - position.fee_growth_inside0).value) * Q128x128::from_u128(position.liquidity);
//     let amount0_fees = amount0_fees.value.b;

//     let amount1_fees = 
//         Q128x128::from_q64x64((range_fee_growth1 - position.fee_growth_inside1).value) * Q128x128::from_u128(position.liquidity);
//     let amount1_fees = amount1_fees.value.b;

//     if add_liquidity {
//         position.liquidity += amount;
//         //TODO: handle overflow
//     } else {
//         position.liquidity -= amount;
//     }

//     // checkpoint fee_growth_inside
//     position.fee_growth_inside0 = range_fee_growth0;
//     position.fee_growth_inside1 = range_fee_growth1;

//     // update storage map
//     storage.positions.insert((owner, lower, upper), position);
    
//     (amount0_fees, amount1_fees)
// }

//  #[storage(read, write)]
// fn _update_fees(token_zero_to_one: bool, fee_growth_global: Q64x64, protocol_fee: u64) {
//      if token_zero_to_one {
//          storage.fee_growth_global1 = fee_growth_global;
//          storage.token1_protocol_fee += protocol_fee;
//      } else {
//          storage.fee_growth_global0 = fee_growth_global;
//          storage.token0_protocol_fee += protocol_fee;
//      }

//     ()
// }

// #[storage(read, write)]
// fn _swap_update_reserves(token_zero_to_one: bool, amount_in: u64, amount_out: u64) {

//     if token_zero_to_one  {
//         storage.reserve0 += amount_in;
//         storage.reserve1 -= amount_out;
//     } else {
//         storage.reserve1 += amount_in;
//         storage.reserve0 -= amount_out;
//     }
// }

// #[storage(read, write)]
// fn _position_update_reserves(add_liquidity: bool, token0_amount: u64, token1_amount: u64) {

//     if add_liquidity {
//         storage.reserve0 += token0_amount;
//         storage.reserve1 += token1_amount;
//     } else {
//         storage.reserve0 -= token0_amount;
//         storage.reserve1 -= token1_amount;
//     }
// }

// #[storage(read)]
// fn range_fee_growth(lower_tick : I24, upper_tick: I24) -> (Q64x64, Q64x64) {
//     let current_tick = storage.nearest_tick;

//     let lower: Tick = storage.ticks.get(lower_tick);
//     let upper: Tick = storage.ticks.get(upper_tick);

//     let _fee_growth_global0 = storage.fee_growth_global0;
//     let _fee_growth_global1 = storage.fee_growth_global1;

//     let mut fee_growth_below0:Q64x64 = Q64x64::from_uint(0);
//     let mut fee_growth_below1:Q64x64 = Q64x64::from_uint(0);
//     let mut fee_growth_above0:Q64x64 = Q64x64::from_uint(0);
//     let mut fee_growth_above1:Q64x64 = Q64x64::from_uint(0);

//     if lower_tick < current_tick || lower_tick == current_tick {
//         fee_growth_below0 = lower.fee_growth_outside0;
//         fee_growth_below1 = lower.fee_growth_outside1;
//     } else {
//         fee_growth_below0 = _fee_growth_global0 - lower.fee_growth_outside0;
//         fee_growth_below1 = _fee_growth_global1 - lower.fee_growth_outside1;
//     }

//     if (current_tick < upper_tick) {
//         fee_growth_above0 = upper.fee_growth_outside0;
//         fee_growth_above1 = upper.fee_growth_outside1;
//     } else {
//         fee_growth_above0 = _fee_growth_global0 - upper.fee_growth_outside0;
//         fee_growth_above1 = _fee_growth_global1 - upper.fee_growth_outside1;
//     }

//     let fee_growth_inside0 = _fee_growth_global0 - fee_growth_below0 - fee_growth_above0;
//     let fee_growth_inside1 = _fee_growth_global1 - fee_growth_below1 - fee_growth_above1;

//     (fee_growth_inside0, fee_growth_inside1)
// }

// fn empty_tick() -> Tick {
//     Tick {
//         prev_tick: I24::from_uint(0),
//         next_tick: I24::from_uint(0),
//         liquidity: U128{upper:0, lower:0},
//         fee_growth_outside0: Q64x64::from_uint(0),
//         fee_growth_outside1: Q64x64::from_uint(0),
//         seconds_growth_outside: U128{upper:0, lower:0},
//     }
// }

// // Downcast from u64 to u32, losing precision
// fn u64_to_u32(a: u64) -> u32 {
//     let result: u32 = a;
//     result
// }

// //need to create U128 tick cast function in tick_math to clean up implementation
// pub fn max_liquidity(tick_spacing: u32) -> U128 {
//     //max U128 range
//     let max_u128 = U128::max();

//     //cast max_tick to U128
//     let max_tick_i24 = I24::max();
//     let max_tick_u32 = max_tick_i24.abs();
//     let max_tick_u64: u64 = max_tick_u32;
//     let max_tick_u128 = U128::from((0, max_tick_u64));

//     //cast tick_spacing to U128
//     let tick_spacing_u64: u64 = tick_spacing;
//     let tick_spacing_u128 = U128::from((0, tick_spacing_u64));

//     //liquidity math
//     let double_tick_spacing = tick_spacing_u128 * (U128{upper: 0, lower: 2});
//     let range_math = max_u128 / max_tick_u128;
//     let liquidity_math = range_math / double_tick_spacing;

//     liquidity_math
// }
// #[storage(read, write)]
// fn tick_cross(
//     ref mut next: I24, 
//     seconds_growth_global: U256,
//     ref mut liquidity: U128,
//     fee_growth_globalA: Q64x64,
//     fee_growth_globalB: Q64x64, 
//     token_zero_to_one: bool,
//     tick_spacing: I24
// ) -> (U128, I24) {
//     //get seconds_growth from next in StorageMap
//     let mut stored_tick = storage.ticks.get(next).read();
//     let outside_growth = storage.ticks.get(next).read().seconds_growth_outside;

//     //cast outside_growth into U256
//     let seconds_growth_outside = U256{a:0,b:0,c:outside_growth.upper,d:outside_growth.lower};

//     //do the math, downcast to U128, store in storage.ticks
//     let outside_math: U256 = seconds_growth_global - seconds_growth_outside;
//     let outside_downcast = U128{upper: outside_math.c, lower: outside_math.d};
//     stored_tick.seconds_growth_outside = outside_downcast;
//     storage.ticks.insert(next, stored_tick);

//     let modulo_re_to24 = I24::from_uint(2);
//     let i24_zero = I24::from_uint(0);

//     if token_zero_to_one {
//         if ((next / tick_spacing) % modulo_re_to24) == i24_zero {
//             liquidity -= storage.ticks.get(next).read().liquidity;
//         } else{
//             liquidity += storage.ticks.get(next).read().liquidity;
//         }
//         //cast to Q64x64
//         let mut new_stored_tick: Tick = storage.ticks.get(next).read();

//         //do the math
//         let fee_g_0 = fee_growth_globalB - new_stored_tick.fee_growth_outside0;
//         let fee_g_1 = fee_growth_globalA - new_stored_tick.fee_growth_outside1;

//         //push to new_stored_tick
//         new_stored_tick.fee_growth_outside0 = fee_g_0;
//         new_stored_tick.fee_growth_outside1 = fee_g_1;

//         next = storage.ticks.get(next).read().prev_tick;    
//     }
    
//     else {
//         if ((next / tick_spacing) % modulo_re_to24) == i24_zero {
//             liquidity += storage.ticks.get(next).read().liquidity;
//         } else{
//             liquidity -= storage.ticks.get(next).read().liquidity;
//         }

//         let mut new_stored_tick: Tick = storage.ticks.get(next).read();

//         //do the math
//         let fee_g_0 = fee_growth_globalA - new_stored_tick.fee_growth_outside0;
//         let fee_g_1 = fee_growth_globalB - new_stored_tick.fee_growth_outside1;

//         //push to new_stored_tick
//         new_stored_tick.fee_growth_outside0 = fee_g_0;
//         new_stored_tick.fee_growth_outside1 = fee_g_1;

//         //push onto storagemap
//         storage.ticks.insert(next, new_stored_tick);

//         //change input tick to previous tick
//         next = storage.ticks.get(next).read().prev_tick;
//     }
//     (liquidity, next)
// }

// #[storage(read, write)]
// fn tick_insert(
//     amount: U128,
//     above: I24, below: I24, 
//     prev_above: I24, prev_below: I24
// ) -> I24 {
//     // check inputs
//     require(below < above);
//     require(below > MIN_TICK() || below == MIN_TICK());
//     require(above < MAX_TICK() || above == MAX_TICK());
    
//     let mut below_tick = storage.ticks.get(below);
//     let mut nearest = storage.nearest_tick;

//     if below_tick.liquidity != (U128{upper: 0, lower: 0}) || below == MIN_TICK() {
//         // tick has already been initialized
//         below_tick.liquidity += amount;
//         storage.ticks.insert(below, below_tick);
//     } else {
//         // tick has not been initialized
//         let mut prev_tick = storage.ticks.get(prev_below);
//         let prev_next = prev_tick.next_tick;
//         let below_next = if above < prev_tick.next_tick { above } else { prev_tick.next_tick };

//         // check below ordering
//         require(prev_tick.liquidity != (U128{upper: 0, lower: 0}) || prev_below == MIN_TICK());
//         require(prev_below < below && below < prev_above);
        
//         if below < nearest || below == nearest {
//             storage.ticks.insert(below, Tick {
//                 prev_tick: prev_below,
//                 next_tick: below_next,
//                 liquidity: amount,
//                 fee_growth_outside0: storage.fee_growth_global0,
//                 fee_growth_outside1: storage.fee_growth_global1,
//                 seconds_growth_outside: U128{upper:storage.seconds_growth_global.c, lower:storage.seconds_growth_global.d},
//             });
//         } else {
//             storage.ticks.insert(below, Tick {
//                 prev_tick: prev_below,
//                 next_tick: prev_next,
//                 liquidity: amount,
//                 fee_growth_outside0: Q64x64::from_uint(0),
//                 fee_growth_outside1: Q64x64::from_uint(0),
//                 seconds_growth_outside: (U128{upper: 0, lower: 0})
//             });
//         }
//         prev_tick.next_tick = below;
//         storage.ticks.insert(prev_next, prev_tick);
//     }

//     let mut above_tick = storage.ticks.get(above);

//     if above_tick.liquidity != (U128{upper: 0, lower: 0}) || above == MAX_TICK() {
//         above_tick.liquidity += amount;
//         storage.ticks.insert(above, above_tick);
//     } else {
//         let mut prev_tick = storage.ticks.get(prev_above);
//         let mut prev_next = prev_tick.next_tick;

//         // check above order
//         require(prev_tick.liquidity != (U128{upper: 0, lower: 0}));
//         require(prev_next > above);
//         require(prev_above < above);

//         let above_prev = if prev_tick.prev_tick < below { below } else { prev_above };

//         if above < nearest || above == nearest {
//             storage.ticks.insert(above, Tick {
//                 prev_tick: above_prev,
//                 next_tick: prev_next,
//                 liquidity: amount,
//                 fee_growth_outside0: storage.fee_growth_global0,
//                 fee_growth_outside1: storage.fee_growth_global1,
//                 seconds_growth_outside: U128{upper:storage.seconds_growth_global.c, lower:storage.seconds_growth_global.d},
//             });
//         } else {
//             storage.ticks.insert(above, Tick {
//                 prev_tick: prev_above,
//                 next_tick: prev_next,
//                 liquidity: amount,
//                 fee_growth_outside0: Q64x64::from_uint(0),
//                 fee_growth_outside1: Q64x64::from_uint(0),
//                 seconds_growth_outside: (U128{upper: 0, lower: 0})
//             });
//         }
//         prev_tick.next_tick = above;
//         storage.ticks.insert(prev_above, prev_tick);
//         let mut prev_next_tick = storage.ticks.get(prev_next);
//         prev_next_tick.prev_tick = above;
//         storage.ticks.insert(prev_next, prev_next_tick);
//     }

//     let tick_at_price: I24 = get_tick_at_price(storage.sqrt_price);

//     let above_is_between: bool = nearest < above && (above < tick_at_price || above == tick_at_price);
//     let below_is_between: bool = nearest < below && (below < tick_at_price || below == tick_at_price);
    
//     if above_is_between {
//         nearest = above;
//     } else if below_is_between {
//         nearest = below;
//     }
    
//     nearest
// }

// #[storage(read, write)]
// fn tick_remove(
//     below: I24, above: I24,
//     amount: U128,
//     ref mut nearest: I24,
// ) -> I24 {
//     let mut current_tick = storage.ticks.get(below);
//     let mut prev = current_tick.prev_tick;
//     let mut next = current_tick.next_tick;
//     let mut prev_tick = storage.ticks.get(prev);
//     let mut next_tick = storage.ticks.get(next);

//     if below != MIN_TICK() && current_tick.liquidity == amount {
//         // clear below tick from storage
//         prev_tick.next_tick = current_tick.next_tick;
//         next_tick.prev_tick = current_tick.prev_tick;

//         if nearest == below {
//             nearest = current_tick.prev_tick;
//         }
        
//         storage.ticks.insert(below, empty_tick());
//         storage.ticks.insert(prev, prev_tick);
//         storage.ticks.insert(next, next_tick);

//     } else {
//         current_tick.liquidity += amount;
//         storage.ticks.insert(below, current_tick);
//     }

//     current_tick = storage.ticks.get(above);
//     prev = current_tick.prev_tick;
//     next = current_tick.next_tick;
//     prev_tick = storage.ticks.get(prev);
//     next_tick = storage.ticks.get(next);

//     if above != MAX_TICK() && current_tick.liquidity == amount {
//         // clear above tick from storage
//         prev_tick.next_tick = next;
//         next_tick.prev_tick = prev;

//         if nearest == above {
//             nearest = current_tick.prev_tick;
//         }

//         storage.ticks.insert(above, empty_tick());
//         storage.ticks.insert(prev, prev_tick);
//         storage.ticks.insert(next, next_tick);

//     } else {
//         current_tick.liquidity -= amount;
//         storage.ticks.insert(above, current_tick);
//     }

//     nearest