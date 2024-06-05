library;

impl SubId {
    pub fn from(value: u32) -> Self {
        value.as_u256().as_b256()
    }
}