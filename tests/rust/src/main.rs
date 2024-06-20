use std::str::FromStr;

extern crate fuels;

use fuels::{crypto::SecretKey, prelude::*};

fn main() {
    println!("Hello, world!");

    // Create a provider pointing to the testnet.
    let provider = Provider::connect("testnet.fuel.network").await.unwrap();

    // Setup a private key
    let secret = SecretKey::from_str(
        "830499a7b3ed234ab617ad6c402c623d0b4318cc4737059c28169e239a25101d",
    );

    let wallet = WalletUnlocked::new_from_private_key(secret.expect("INVALID SECRET"), Some(provider));

    // // Get the wallet address. Used later with the faucet
    // dbg!(wallet.address().to_string());

    // println!("Wallet address:");
    // println!("{}", wallet.address().to_string());
}