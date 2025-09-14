use starknet::{ContractAddress};
use aster::utils::hash::{make_seed};

#[dojo::model]
#[derive(Copy, Drop, Serde)]
pub struct Seed {
    #[key]
    pub token_id: u128,
    pub seed: felt252,
}

#[derive(Copy, Drop, Serde)]
pub struct Seeder {
    pub seed: felt252,
    pub current: u256,
    pub token_id: u128,
}


//---------------------------------------
// Traits
//
use aster::utils::hash::{hash_values};

#[generate_trait]
pub impl SeedImpl of SeedTrait {
    fn new(contract_address: ContractAddress, token_id: u128) -> Seed {
        let seed: felt252 = make_seed(contract_address, token_id);
        (Seed { token_id, seed })
    }
}

#[generate_trait]
pub impl SeederImpl of SeederTrait {
    fn new(seed: felt252, token_id: u128) -> Seeder {
        (Seeder {
            seed,
            current: seed.into(),
            token_id,
        })
    }
    fn get_next_u8(ref self: Seeder, max_exclusive: u8) -> u8 {
        ((self._next(max_exclusive.into(), 0xff, 0x100)).try_into().unwrap())
    }
    fn get_next_u8_usize(ref self: Seeder, max_exclusive: u32) -> u32 {
        ((self._next(max_exclusive.into(), 0xff, 0x100)).try_into().unwrap())
    }
    fn get_next_u16(ref self: Seeder, max_exclusive: u16) -> u16 {
        ((self._next(max_exclusive.into(), 0xffff, 0x10000)).try_into().unwrap())
    }
    fn get_next_u16_usize(ref self: Seeder, max_exclusive: usize) -> usize {
        ((self._next(max_exclusive.into(), 0xffff, 0x10000)).try_into().unwrap())
    }
    #[inline(always)]
    fn _next(ref self: Seeder, max_exclusive: usize, mask: u128, shift: u128) -> u128 {
        let result: u128 = ((self.current.low & mask) % max_exclusive.into());
        self._recycle(shift);
        (result)
    }
    fn _recycle(ref self: Seeder, shift: u128) {
        // shift current value...
        self.current.low = self.current.low / shift;
        // if less than 2 bytes, recycle
        if (self.current.low < 0x100) {
            if (self.current.high != 0) {
                // use high part if available
                self.current.low = self.current.high;
                self.current.high = 0;
            } else {
                // hash original seed for more values
                self.seed = hash_values([self.seed].span());
                self.current = self.seed.into();
            }
        }
    }
}



//----------------------------
// tests
//
#[cfg(test)]
mod unit {
    use super::{Seed, SeedTrait, Seeder, SeederTrait};
    use aster::tests::tester::tester::{OWNER, OTHER};

    #[test]
    fn test_seed_is_unique() {
        let seed_A_1: Seed = SeedTrait::new(OWNER(), 1);
        let seed_A_2: Seed = SeedTrait::new(OWNER(), 2);
        let seed_A_1b: Seed = SeedTrait::new(OWNER(), 1);
        assert_gt!(seed_A_1.seed.into(), 0_u256, "seed_A_1");
        assert_gt!(seed_A_2.seed.into(), 0_u256, "seed_A_2");
        assert_ne!(seed_A_1.seed, seed_A_2.seed, "seed_A_1 <> seed_A_2");
        assert_eq!(seed_A_1.seed, seed_A_1b.seed, "seed_A_1 == seed_A_1b");
        let seed_B_1 = SeedTrait::new(OTHER(), 1);
        let seed_B_2 = SeedTrait::new(OTHER(), 2);
        assert_gt!(seed_B_1.seed.into(), 0_u256, "seed_B_1");
        assert_gt!(seed_B_2.seed.into(), 0_u256, "seed_B_2");
        assert_ne!(seed_B_1.seed, seed_B_2.seed, "seed_B_1 <> seed_B_2");
        assert_ne!(seed_B_1.seed, seed_A_1.seed, "seed_B_1 <> seed_A_1");
        assert_ne!(seed_B_2.seed, seed_A_2.seed, "seed_B_2 <> seed_A_2");
    }

    #[test]
    fn test_seeder() {
        let seed: felt252 = u256 {
            high: 0x5040302010,
            low: 0x07060504030201,
        }.try_into().unwrap();
        let mut seeder: Seeder = SeederTrait::new(seed, 1);
        let value: u8 = seeder.get_next_u8(0xff);
        assert_eq!(value, 0x01, "seeder.get_next_u8()");
        assert_eq!(seeder.seed, seed, "seeder.seed");
        assert_eq!(seeder.current.high, 0x5040302010, "seeder.high");
        assert_eq!(seeder.current.low, 0x070605040302, "seeder.low");
        let value: u16 = seeder.get_next_u16(0xffff);
        assert_eq!(value, 0x0302, "seeder.get_next_u16()");
        assert_eq!(seeder.seed, seed, "seeder.seed");
        assert_eq!(seeder.current.high, 0x5040302010, "seeder.high");
        assert_eq!(seeder.current.low, 0x07060504, "seeder.low");
        let value: u16 = seeder.get_next_u16(0xffff);
        assert_eq!(value, 0x0504, "seeder.get_next_u16()");
        assert_eq!(seeder.seed, seed, "seeder.seed");
        assert_eq!(seeder.current.high, 0x5040302010, "seeder.high");
        assert_eq!(seeder.current.low, 0x0706, "seeder.low");
        // last value, will use high part
        let value: u8 = seeder.get_next_u8(0xff);
        assert_eq!(value, 0x06, "seeder.get_next_u8()");
        assert_eq!(seeder.seed, seed, "seeder.seed");
        assert_eq!(seeder.current.high, 0, "seeder.high");
        assert_eq!(seeder.current.low, 0x5040302010, "seeder.low");
        let value: u16 = seeder.get_next_u16(0xffff);
        assert_eq!(value, 0x2010, "seeder.get_next_u16()");
        assert_eq!(seeder.seed, seed, "seeder.seed");
        assert_eq!(seeder.current.high, 0, "seeder.high");
        assert_eq!(seeder.current.low, 0x504030, "seeder.low");
        let value: u8 = seeder.get_next_u8(0xff);
        assert_eq!(value, 0x30, "seeder.get_next_u16()");
        assert_eq!(seeder.seed, seed, "seeder.seed");
        assert_eq!(seeder.current.high, 0, "seeder.high");
        assert_eq!(seeder.current.low, 0x5040, "seeder.low");
        // last value, will hash new seed
        let value: u8 = seeder.get_next_u8(0xff);
        assert_eq!(value, 0x40, "seeder.get_next_u16()");
        assert_ne!(seeder.seed, seed, "seeder.seed");
        assert_gt!(seeder.current.high, 0xffffffffffffffff, "seeder.high");
        assert_gt!(seeder.current.low, 0xffffffffffffffff, "seeder.low");
    }
}
