library;

use std::address::*;

impl Identity {
    /// Returns the underlying raw `b256` data of the identity.
    ///
    /// # Returns
    ///
    /// * [b256] - The raw data of the identity.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use std::constants::ZERO_B256;
    ///
    /// fn foo() -> {
    ///     let my_identity = Identity::Address(Address::from(ZERO_B256));
    ///     assert(my_identity.bits() == ZERO_B256);
    /// }
    /// ```
    pub fn bits(self) -> b256 {
        match self {
            Self::Address(address) => address.bits(),
            Self::ContractId(contract_id) => contract_id.bits(),
        }
    }
}