library;

impl SubId {
    pub fn default() -> SubId {
        let default_sub_id: SubId = 0x0000000000000000000000000000000000000000000000000000000000000000;
        default_sub_id
    }

    pub fn from(value: u32) -> Self {
        value.as_u256().as_b256()
    }
}