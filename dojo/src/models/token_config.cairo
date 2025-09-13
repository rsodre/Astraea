use starknet::ContractAddress;

#[dojo::model]
#[derive(Copy, Drop, Serde)]
pub struct TokenConfig {
    #[key]
    pub token_address: ContractAddress,
    //------
    pub treasury_address: ContractAddress,
    pub purchase_coin_address: ContractAddress,
    pub purchase_price_wei: u128,
}

//---------------------------------------
// Traits
//
use aster::interfaces::ierc20::{IERC20Dispatcher};

#[generate_trait]
pub impl TokenConfigImpl of TokenConfigTrait {
    fn purchase_coin_dispatcher(self: TokenConfig) -> IERC20Dispatcher {
        (IERC20Dispatcher{ contract_address: self.purchase_coin_address })
    }
}
