use starknet::{ContractAddress};
use dojo::world::{WorldStorage, WorldStorageTrait};

pub use aster::systems::{
    token::{ITokenDispatcher},
    minter::{IMinterDispatcher},
};
use aster::utils::misc::{ZERO};

pub mod SELECTORS {
    // systems
    pub const TOKEN: felt252 = selector_from_tag!("aster-token");
    pub const MINTER: felt252 = selector_from_tag!("aster-minter");
}

#[generate_trait]
pub impl DnsImpl of DnsTrait {
    fn find_contract_address(self: @WorldStorage, contract_name: @ByteArray) -> ContractAddress {
        // let (contract_address, _) = self.dns(contract_name).unwrap(); // will panic if not found
        match self.dns_address(contract_name) {
            Option::Some(contract_address) => {
                (contract_address)
            },
            Option::None => {
                (ZERO())
            },
        }
    }

    //--------------------------
    // system addresses
    //
    #[inline(always)]
    fn token_address(self: @WorldStorage) -> ContractAddress {
        (self.find_contract_address(@"token"))
    }
    #[inline(always)]
    fn minter_address(self: @WorldStorage) -> ContractAddress {
        (self.find_contract_address(@"minter"))
    }

    //--------------------------
    // dispatchers
    //
    #[inline(always)]
    fn token_dispatcher(self: @WorldStorage) -> ITokenDispatcher {
        (ITokenDispatcher{ contract_address: self.token_address() })
    }
    #[inline(always)]
    fn minter_dispatcher(self: @WorldStorage) -> IMinterDispatcher {
        (IMinterDispatcher{ contract_address: self.minter_address() })
    }
}
