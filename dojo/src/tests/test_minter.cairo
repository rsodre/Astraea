#[cfg(test)]
mod tests {
    use starknet::{ContractAddress};
    // use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

    use aster::{
        systems::{minter::{IMinterDispatcherTrait}},
        systems::{token::{ITokenDispatcherTrait}},
        models::token_config::{TokenConfig},
        models::seed::{Seed,},
        models::props::{constants},
        utils::misc::{WEI},
    };

    use aster::tests::{
        tester::{tester},
        tester::tester::{
            TestSystems, FLAGS,
            OWNER, OTHER, BUMMER, SPENDER, RECIPIENT, ZERO, TREASURY,
            StoreTrait,
        },
        mock_coin::{ICoinMockDispatcherTrait},
    };

    fn _approve(sys: TestSystems, account: ContractAddress, quantity: u128) -> u256 {
        let (purchase_coin_address, purchase_price) = sys.minter.get_price();
        assert_eq!(purchase_coin_address, sys.coin.contract_address, "purchase_coin_address");
        let approve_amount: u256 = (purchase_price * quantity).into();
        tester::impersonate(account);
        if (sys.coin.balance_of(account) < approve_amount) {
            sys.coin.faucet();
        }
        sys.coin.approve(sys.minter.contract_address, approve_amount);
        (approve_amount)
    }

    fn _assert_minted(sys: TestSystems, token_id: u128, expected_token_id: u128, owner: ContractAddress, prefix: ByteArray) -> felt252 {
        assert_eq!(token_id, expected_token_id, "[{}]: token_id", prefix);
        assert_eq!(sys.token.total_supply(), token_id.into(), "[{}]: total_supply", prefix);
        assert_eq!(sys.token.owner_of(token_id.into()), owner, "[{}]: owner_of", prefix);
        let seed: Seed = sys.store.get_seed(token_id);
        assert_ne!(seed.seed, 0, "[{}]: seed", prefix);
        (seed.seed)
    }

    fn _assert_can_mint(sys: TestSystems, prefix: ByteArray) {
        let recipient: ContractAddress = tester::get_impersonator();
        let can_mint: Option<ByteArray> = sys.minter.can_mint(recipient, recipient);
        assert!(can_mint.is_none(), "[{}]: can_mint: {}", prefix, can_mint.unwrap());
    }
    fn _assert_cannot_mint(sys: TestSystems, reason: ByteArray) {
        let recipient: ContractAddress = tester::get_impersonator();
        let can_mint: Option<ByteArray> = sys.minter.can_mint(recipient, recipient);
        assert!(can_mint.is_some(), "[{}]: cannot_mint (can mint)", reason);
        assert_eq!(can_mint.unwrap(), reason, "cannot_mint (wrong reason)");
    }

    //---------------------------------------
    // admin
    //

    #[test]
    fn test_initialized() {
        let sys: TestSystems = tester::setup_world(FLAGS::NONE);
        let (purchase_coin_address, purchase_price) = sys.minter.get_price();
        assert_ne!(purchase_coin_address, ZERO(), "purchase_coin_address");
        assert_ne!(purchase_price, 0, "purchase_price: !0");
        assert_eq!(purchase_price, WEI(constants::DEFAULT_STRK_PRICE_ETH.into()), "purchase_price: 50");
    }



    //---------------------------------------
    // mint
    //

    #[test]
    fn test_not_available_owner_can_mint() {
        let sys: TestSystems = tester::setup_world(FLAGS::NONE);
        tester::impersonate(OWNER());
        sys.minter.mint();
    }

    #[test]
    #[should_panic(expected:('ASTRAEA: caller is not minter','ENTRYPOINT_FAILED'))]
    fn test_not_minter() {
        let sys: TestSystems = tester::setup_world(FLAGS::NONE);
        // direct contract minting is not possible
        tester::impersonate(RECIPIENT());
        sys.token.mint_next(RECIPIENT());
    }

    #[test]
    fn test_mint_ok() {
        let sys: TestSystems = tester::setup_world(FLAGS::NONE);
        assert_eq!(sys.token.total_supply(), 0, "supply = 0");
        // mint #1
        _approve(sys, OTHER(), 3);
        tester::impersonate(OTHER());
        _assert_can_mint(sys, "other_mint_1");
        let token_id_1: u128 = sys.minter.mint();
        let seed_1: felt252 = _assert_minted(sys, token_id_1, 1, OTHER(), "TOKEN_1");
        // mint #2
        _assert_can_mint(sys, "other_mint_1");
        let token_id_2: u128 = sys.minter.mint();
        let seed_2: felt252 = _assert_minted(sys, token_id_2, 2, OTHER(), "TOKEN_2");
        _assert_cannot_mint(sys, "Minted maximum");
        assert_ne!(seed_1, 0, "seed_1_zero");
        assert_ne!(seed_2, 0, "seed_2_zero");
        assert_ne!(seed_2, seed_1, "seed_2_1");
        //
        // mint to... 
        tester::impersonate(OTHER());
        let token_id_3: u128 = sys.minter.mint_to(BUMMER());
        let seed_3: felt252 = _assert_minted(sys, token_id_3, 3, BUMMER(), "TOKEN_3");
        assert_ne!(seed_3, 0, "seed_3_zero");
        assert_ne!(seed_3, seed_2, "seed_3_2");
        // mint #4
        _approve(sys, BUMMER(), 1);
        tester::impersonate(BUMMER());
        _assert_can_mint(sys, "bummer_mint_2");
        let token_id_4: u128 = sys.minter.mint();
        let seed_4: felt252 = _assert_minted(sys, token_id_4, 4, BUMMER(), "TOKEN_4");
        assert_ne!(seed_4, 0, "seed_4_zero");
        assert_ne!(seed_4, seed_3, "seed_4_3");
        // no more..
        _assert_cannot_mint(sys, "Minted maximum");
    }

    #[test]
    fn test_purchase_balance() {
        let sys: TestSystems = tester::setup_world(FLAGS::NONE);
        // approve...
        tester::impersonate(OTHER());
        let amount_approved: u256 = _approve(sys, OTHER(), 3);
        let balance_other: u256 = sys.coin.balance_of(OTHER());
        assert_gt!(amount_approved, 0, "amount_approved_BEFORE");
        assert_gt!(balance_other, amount_approved, "balance_other_BEFORE");
        assert_eq!(sys.coin.balance_of(TREASURY()), 0, "balance_treasury_BEFORE");
        // mint all...
        tester::impersonate(OTHER());
        sys.minter.mint();
        sys.minter.mint_to(SPENDER());
        sys.minter.mint_to(RECIPIENT());
        // balance moved to treasury
        assert_eq!(sys.coin.balance_of(OTHER()), (balance_other - amount_approved), "balance_approved_AFTER");
        assert_eq!(sys.coin.balance_of(TREASURY()), amount_approved, "balance_treasury_AFTER");
    }

    #[test]
    #[should_panic(expected:('MINTER: minted maximum','ENTRYPOINT_FAILED'))]
    fn test_mint_maximum() {
        let sys: TestSystems = tester::setup_world(FLAGS::NONE);
        _approve(sys, OTHER(), 3);
        tester::impersonate(OTHER());
        sys.minter.mint();
        sys.minter.mint();
        sys.minter.mint();
        _assert_cannot_mint(sys, "Minted maximum");
        sys.minter.mint();
    }


    //---------------------------------------
    // admin
    //

    #[test]
    fn test_mint_set_paused() {
        let sys: TestSystems = tester::setup_world(FLAGS::NONE);
        // pause
        assert!(!sys.token.is_minting_paused(), "paused:START");
        tester::impersonate(OWNER());
        sys.token.set_paused(true);
        assert!(sys.token.is_minting_paused(), "paused:true");
        // mint...?
        tester::impersonate(OTHER());
        _approve(sys, OTHER(), 1);
        _assert_cannot_mint(sys, "Paused");
        // unpause...
        tester::impersonate(OWNER());
        sys.token.set_paused(false);
        tester::impersonate(OTHER());
        _approve(sys, OTHER(), 1);
        _assert_can_mint(sys, "unpaused");
        sys.minter.mint();
    }

    #[test]
    #[should_panic(expected:('MINTER: mint paused','ENTRYPOINT_FAILED'))]
    fn test_mint_paused() {
        let sys: TestSystems = tester::setup_world(FLAGS::NONE);
        // pause
        tester::impersonate(OWNER());
        sys.token.set_paused(true);
        // mint...?
        _approve(sys, OTHER(), 1);
        tester::impersonate(OTHER());
        _assert_cannot_mint(sys, "Paused");
        sys.minter.mint();
    }

    #[test]
    fn test_admin_set_purchase_price_ok() {
        let sys: TestSystems = tester::setup_world(FLAGS::NONE);
        tester::impersonate(OWNER());
        // initial state
        let config: TokenConfig = sys.store.get_token_config(sys.token.contract_address);
        assert_ne!(config.purchase_coin_address, ZERO(), "purchase_coin_address_INIT");
        assert_ne!(config.purchase_price_wei, 0, "purchase_price_wei_INIT");
        // config...
        sys.minter.set_purchase_price(OTHER(), 222);
        let config: TokenConfig = sys.store.get_token_config(sys.token.contract_address);
        assert_eq!(config.purchase_coin_address, OTHER(), "purchase_coin_address_AFTER");
        assert_eq!(config.purchase_price_wei, WEI(222), "purchase_price_wei_AFTER");
        // get price...
        let (purchase_coin_address, purchase_price) = sys.minter.get_price();
        assert_eq!(purchase_coin_address, config.purchase_coin_address, "purchase_coin_address_GET");
        assert_eq!(purchase_price, config.purchase_price_wei, "purchase_price_GET");
    }

    #[test]
    #[should_panic(expected:('MINTER: caller is not owner','ENTRYPOINT_FAILED'))]
    fn test_admin_set_purchase_price_not_owner() {
        let sys: TestSystems = tester::setup_world(FLAGS::NONE);
        tester::impersonate(OTHER());
        sys.minter.set_purchase_price(OTHER(), 255);
    }


}
