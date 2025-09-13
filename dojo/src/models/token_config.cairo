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
    pub max_per_wallet: u8,
}

//---------------------------------------
// Traits
//
use aster::systems::token::{ITokenDispatcherTrait};
use aster::libs::store::{Store};
use aster::libs::dns::{DnsTrait};
use aster::interfaces::ierc20::{IERC20Dispatcher};

#[generate_trait]
pub impl TokenConfigImpl of TokenConfigTrait {
    fn account_can_mint(self: TokenConfig, store: @Store, account_address: ContractAddress) -> bool {
        (store.world.token_dispatcher().balance_of(account_address) < self.max_per_wallet.into())
    }
    fn purchase_coin_dispatcher(self: TokenConfig) -> IERC20Dispatcher {
        (IERC20Dispatcher{ contract_address: self.purchase_coin_address })
    }
}
