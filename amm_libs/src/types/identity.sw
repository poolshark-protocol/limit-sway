library;

impl ContractId {
    /// Returns the underlying raw `b256` data of the contract id.
    ///
    /// # Returns
    ///
    /// * [b256] - The raw data of the contract id.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use std::constants::ZERO_B256;
    ///
    /// fn foo() -> {
    ///     let my_contract = ContractId::from(ZERO_B256);
    ///     assert(my_contract.bits() == ZERO_B256);
    /// }
    /// ```
    pub fn bits(self) -> b256 {
        self.value
    }
}

impl Address {
    /// Returns the underlying raw `b256` data of the address.
    ///
    /// # Returns
    ///
    /// * [b256] - The raw data of the address.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use std::constants::ZERO_B256;
    ///
    /// fn foo() -> {
    ///     let my_address = Address::from(ZERO_B256);
    ///     assert(my_address.bits() == ZERO_B256);
    /// }
    /// ```
    pub fn bits(self) -> b256 {
        self.value
    }
}

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