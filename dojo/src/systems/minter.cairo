use starknet::{ContractAddress};

#[starknet::interface]
pub trait IMinter<TState> {
    fn get_price(self: @TState) -> (ContractAddress, u128);
    fn can_mint(self: @TState, recipient: ContractAddress) -> Option<ByteArray>;
    fn mint(ref self: TState) -> u128;
    fn mint_to(ref self: TState, recipient: ContractAddress) -> u128;

    // admin
    fn set_purchase_price(ref self: TState, purchase_coin_address: ContractAddress, purchase_price_eth: u8);
}

#[dojo::contract]
pub mod minter {
    use core::num::traits::Zero;
    use starknet::{ContractAddress};
    use dojo::world::{WorldStorage, IWorldDispatcherTrait};

    use aster::systems::token::{ITokenDispatcherTrait};
    use aster::interfaces::ierc20::{IERC20Dispatcher, IERC20DispatcherTrait};
    use aster::libs::store::{Store, StoreTrait};
    use aster::libs::dns::{DnsTrait, SELECTORS};
    use aster::utils::misc::{WEI};
    use aster::models::{
        token_config::{TokenConfig, TokenConfigTrait},
        props::{constants},
    };
    use aster::utils::math::{SafeMathU64};
    
    mod Errors {
        pub const CALLER_IS_NOT_OWNER: felt252      = 'MINTER: caller is not owner';
        pub const INVALID_TREASURY_ADDRESS: felt252 = 'MINTER: invalid treasury';
        pub const INVALID_COIN_ADDRESS: felt252     = 'MINTER: invalid coin address';
        pub const MINTING_PAUSED: felt252           = 'MINTER: mint paused';
        pub const MINTED_MAXIMUM: felt252           = 'MINTER: minted maximum';
        pub const INVALID_RECEIVER: felt252         = 'MINTER: invalid receiver';
        pub const INSUFFICIENT_ALLOWANCE: felt252   = 'MINTER: insufficient allowance';
        pub const INSUFFICIENT_BALANCE: felt252     = 'MINTER: insufficient balance';
    }

    //---------------------------------------
    // params passed from overlays files
    // https://github.com/dojoengine/dojo/blob/328004d65bbbf7692c26f030b75fa95b7947841d/examples/spawn-and-move/manifests/dev/overlays/contracts/dojo_examples_others_others.toml
    // https://github.com/dojoengine/dojo/blob/328004d65bbbf7692c26f030b75fa95b7947841d/examples/spawn-and-move/src/others.cairo#L18
    // overlays generated with: sozo migrate --generate-overlays
    //
    fn dojo_init(ref self: ContractState,
        treasury_address: ContractAddress,
        purchase_coin_address: ContractAddress, // STRK
    ) {
        let mut store: Store = StoreTrait::new(self.world_default());
        assert(treasury_address.is_non_zero(), Errors::INVALID_TREASURY_ADDRESS);
        assert(purchase_coin_address.is_non_zero(), Errors::INVALID_COIN_ADDRESS);
        store.set_token_config(@TokenConfig{
            token_address: store.world.token_address(),
            treasury_address,
            purchase_coin_address,
            purchase_price_wei: WEI(constants::DEFAULT_STRK_PRICE_ETH.into()),
            max_per_wallet: constants::MAX_PER_WALLET,
        });
    }

    #[generate_trait]
    impl WorldDefaultImpl of WorldDefaultTrait {
        #[inline(always)]
        fn world_default(self: @ContractState) -> WorldStorage {
            (self.world(@"aster"))
        }
    }

    //---------------------------------------
    // IMinter
    //
    #[abi(embed_v0)]
    impl MinterImpl of super::IMinter<ContractState> {
        fn get_price(self: @ContractState) -> (ContractAddress, u128) {
            let mut store: Store = StoreTrait::new(self.world_default());
            let token_config: TokenConfig = TokenConfigTrait::get(@store);
            (token_config.purchase_coin_address, token_config.purchase_price_wei)
        }

        fn can_mint(self: @ContractState, recipient: ContractAddress) -> Option<ByteArray> {
            let mut store: Store = StoreTrait::new(self.world_default());
            let token_config: TokenConfig = TokenConfigTrait::get(@store);
            let token_dispatcher = store.world.token_dispatcher();
            if (token_dispatcher.is_minted_out()) {
                (Option::Some("Minted out"))
            } else if (token_dispatcher.is_minting_paused()) {
                (Option::Some("Paused"))
            } else if (!token_config.account_can_mint(@store, recipient)) {
                (Option::Some("Minted maximum"))
            } else if (token_dispatcher.available_supply() == 0) {
                (Option::Some("Unavailable"))
            } else if (token_config.purchase_coin_dispatcher().balance_of(starknet::get_caller_address()) < token_config.purchase_price_wei.into()) {
                (Option::Some("Insufficient balance"))
            } else {
                // can mint!
                (Option::None)
            }
        }


        fn mint(ref self: ContractState) -> u128 {
            (self.mint_to(starknet::get_caller_address()))
        }

        fn mint_to(ref self: ContractState, recipient: ContractAddress) -> u128 {
            // check availability
            let store: Store = StoreTrait::new(self.world_default());
            let token_config: TokenConfig = TokenConfigTrait::get(@store);
            let token_dispatcher = store.world.token_dispatcher();
            
            // check current minting rules...
            // (contract owner is always allowed to mint)
            if (!self._caller_is_owner()) {
                let caller: ContractAddress = starknet::get_caller_address();

                // validate
                assert(!token_dispatcher.is_minting_paused(), Errors::MINTING_PAUSED);
                assert(token_config.account_can_mint(@store, recipient), Errors::MINTED_MAXIMUM);

                // charge!
                if (token_config.purchase_price_wei != 0) {
                    // must have balance
                    let coin_dispatcher: IERC20Dispatcher = token_config.purchase_coin_dispatcher();
                    let balance: u256 = coin_dispatcher.balance_of(caller);
                    let amount: u256 = token_config.purchase_price_wei.into();
                    assert(balance >= amount, Errors::INSUFFICIENT_BALANCE);
                    // must have allowance
                    let allowance: u256 = coin_dispatcher.allowance(caller, starknet::get_contract_address());
                    assert(allowance >= amount, Errors::INSUFFICIENT_ALLOWANCE);
                    // transfer...
                    assert(token_config.treasury_address.is_non_zero(), Errors::INVALID_RECEIVER);
                    coin_dispatcher.transfer_from(caller, token_config.treasury_address, amount);
                }
            }

            // mint!
            let token_id: u128 = token_dispatcher.mint_next(recipient);
            (token_id)
        }


        //---------------------------------------
        // admin
        //
        fn set_purchase_price(ref self: ContractState, purchase_coin_address: ContractAddress, purchase_price_eth: u8) {
            self._assert_caller_is_owner();
            let mut store: Store = StoreTrait::new(self.world_default());
            let mut token_config: TokenConfig = TokenConfigTrait::get(@store);
            token_config.purchase_coin_address = purchase_coin_address;
            token_config.purchase_price_wei = WEI(purchase_price_eth.into());
            store.set_token_config(@token_config);
        }
    }

    //-----------------------------------
    // Internal
    //
    #[generate_trait]
    impl InternalImpl of InternalTrait {
        #[inline(always)]
        fn _assert_caller_is_owner(self: @ContractState) {
            assert(self._caller_is_owner(), Errors::CALLER_IS_NOT_OWNER);
        }
        #[inline(always)]
        fn _caller_is_owner(self: @ContractState) -> bool {
            let mut world = self.world_default();
            (world.dispatcher.is_owner(SELECTORS::MINTER, starknet::get_caller_address()))
        }
    }

}
