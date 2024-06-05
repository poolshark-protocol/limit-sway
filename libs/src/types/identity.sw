library;

use std::constants::ZERO_B256;

impl Identity {
    pub fn zero() -> Identity {
        Identity::ContractId(ContractId::from(ZERO_B256))
    }
}