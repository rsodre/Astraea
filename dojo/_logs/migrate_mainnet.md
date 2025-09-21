# 2025-09-21 / mainnet

```
$ date
Sun Sep 21 15:20:56 -03 2025

$ ./migrate mainnet          
:mainnet
get_profile_env(world_block) not found! 👎
------------------------------------------------------------------------------
Profile    : mainnet
Project    : Astraea (Starktember 2025)
PC Url     : https://api.cartridge.gg/x/starknet/mainnet
Chain Id   : SN_MAIN
World      : 0x7774946aab21c0b2b2484aa9a6f03bb64fd33550bb2cc8b22d46922b49af17c
Account    : 0x015aF5935c1CBd913B069973aB162c364a03eB6e3Ea311d50a06A8C2bA060AC8
::token    : 0x30f694df2a04e04cf3e1d3e79dd5aadfdaa77295bb007696222fc60a5e8730d
::minter   : 0x4e9848ac6d4dea5725e1869619b72a71b3fa1e56c6fac500a43d090cd882928
manifest   : ./manifest_mainnet.json
------------------------------------------------------------------------------
BINDINGS_PATH: ../client/src/generated
SDK_GAME_PATH: 
CLIENT_GEN_PATH: ../client/src/generated
------------------------------------------------------------------------------
sozo 1.7.0-alpha.4
scarb: scarb 2.12.2 (dc0dbfd50 2025-09-15)
cairo: 2.12.2 (https://crates.io/crates/cairo-lang-compiler/2.12.2)
sierra: 1.7.0
------------------------------------------------------------------------------
>>> Cleaning...
🚦 execute: sozo -P mainnet  clean
>>> Building...
🚦 execute: sozo -P mainnet  build
warn: in context of a workspace, only the `profile` set in the workspace manifest is applied,
but the `example` package also defines `profile` in the manifest

   Compiling dojo_macros v1.7.0-alpha.4 (git+https://github.com/dojoengine/dojo?tag=v1.7.0-alpha.4#7b78108ce7aea7753c0a9e34cb83465a76bbf2e4)
    Finished `release` profile [optimized] target(s) in 0.27s
   Compiling aster v1.0.0 (/Users/roger/Dev/Realms/ASTER/dojo/Scarb.toml)
    Finished `mainnet` profile target(s) in 11 seconds
👍
------------------------------------------------------------------------------
>>> Inspect migrations...
🚦 execute: sozo -P mainnet  inspect --world 0x7774946aab21c0b2b2484aa9a6f03bb64fd33550bb2cc8b22d46922b49af17c

 World   | Contract Address                                                   | Class Hash                                                         
---------+--------------------------------------------------------------------+--------------------------------------------------------------------
 Created | 0x07774946aab21c0b2b2484aa9a6f03bb64fd33550bb2cc8b22d46922b49af17c | 0x057994b6a75fad550ca18b41ee82e2110e158c59028c4478109a67965a0e5b1e 

 Namespaces | Status  | Dojo Selector                                                      
------------+---------+--------------------------------------------------------------------
 aster      | Created | 0x0513f1fe0356a70aa9aa6a232dbff898ce666c7b8926fe5a133986df22f17000 

 Contracts    | Status  | Is Initialized | Dojo Selector                                                      | Contract Address                                                   
--------------+---------+----------------+--------------------------------------------------------------------+--------------------------------------------------------------------
 aster-minter | Created | false          | 0x036eac7d7164bd0a40a0f4e02091aabf72c6ecea97cff8f2b10240f848610f8d | 0x04851d9a0912b6c4b964aeb11207ec2b90938e8136ee9efe9b55ab3a74839579 
 aster-token  | Created | false          | 0x04bb82dc1d2634f44aa08ce225e71a4909c42834710a7c46df06ec0120143a34 | 0x0191e5a4490bf246a9acd76d17bd2e3eb208eb7f5c0795dc4848f338b2e27277 

 Models            | Status  | Dojo Selector                                                      
-------------------+---------+--------------------------------------------------------------------
 aster-Seed        | Created | 0x032603ae72eea61056fed2e38e5ff52b4c5e458e1352bd06523243c011e4956d 
 aster-TokenConfig | Created | 0x06649cfa36f3ab516b4e7b10b58a47efe4bc1c3b6706a170c3e7f86c4b80dde6 

 Events                 | Status  | Dojo Selector                                                      
------------------------+---------+--------------------------------------------------------------------
 aster-TokenBurnedEvent | Created | 0x051377a8e2d9dadf4e7edb78bfc06ec12b9855a396706556ca0b5cc16184e2f0 
 aster-TokenMintedEvent | Created | 0x057b7e43cf043309f0dfc74e052929aa1eb82717dd4dc4dd513c334bc0406b8d 

>>> Do migrations...
🚦 execute: sozo -P mainnet  migrate --world 0x7774946aab21c0b2b2484aa9a6f03bb64fd33550bb2cc8b22d46922b49af17c 

 profile | chain_id | rpc_url                                     
---------+----------+---------------------------------------------
 mainnet | SN_MAIN  | https://api.cartridge.gg/x/starknet/mainnet 

                                 
🌍 World deployed at block 2345258 with txn hash: 0x01881346c2fb82ad12d32443d6277cb7090a2f439388c8dbabc355e1164a71f9
🗡️  Initializing 2 contracts...      
IPFS credentials not found. Metadata upload skipped. To upload metadata, configure IPFS credentials in your profile config or environment variables: https://book.dojoengine.org/framework/world/metadata.
⛩️  Migration successful with world at address 0x07774946aab21c0b2b2484aa9a6f03bb64fd33550bb2cc8b22d46922b49af17c
👍
------------------------------------------------------------------------------
>>> Copying manifest [./manifest_mainnet.json] to [../client/src/generated/]
total 504
-rw-r--r--@ 1 roger  staff  84641 Sep 21 15:10 manifest_dev.json
-rw-r--r--@ 1 roger  staff  84706 Sep 21 15:26 manifest_mainnet.json
-rw-r--r--@ 1 roger  staff  84706 Sep 21 15:10 manifest_sepolia.json
drwxr-xr-x@ 4 roger  staff    128 Sep 14 15:07 typescript
>>> Copying manifest [./manifest_mainnet.json] to [../../../CC/cc-dapp-v2/web/src/networks/generated/aster/]
cp: directory ../../../CC/cc-dapp-v2/web/src/networks/generated/aster does not exist

$ scripts/set_paused.sh mainnet 1
:mainnet
:1
------------------------------------------------------------------------------
Profile    : mainnet
Project    : Astraea (Starktember 2025)
PC Url     : https://api.cartridge.gg/x/starknet/mainnet
Chain Id   : SN_MAIN
World      : 0x7774946aab21c0b2b2484aa9a6f03bb64fd33550bb2cc8b22d46922b49af17c
Account    : 0x015aF5935c1CBd913B069973aB162c364a03eB6e3Ea311d50a06A8C2bA060AC8
::token    : 0x191e5a4490bf246a9acd76d17bd2e3eb208eb7f5c0795dc4848f338b2e27277
::minter   : 0x4851d9a0912b6c4b964aeb11207ec2b90938e8136ee9efe9b55ab3a74839579
manifest   : ./manifest_mainnet.json
------------------------------------------------------------------------------
> new paused: 1
Transaction hash: 0x078a676de03005cf7bf92b51125e304392e3aac0c23a73e76b1d29f89bdfc602
{
    token_address   : 0x0191e5a4490bf246a9acd76d17bd2e3eb208eb7f5c0795dc4848f338b2e27277,
    treasury_address: 0x05730fc9e88a6ab94f782e520812e272714d27221fbda848a56e903c57be6062,
    purchase_coin_address: 0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d,
    purchase_price_wei: 0x000000000000000ad78ebc5ac6200000,
    max_per_wallet  : 2
}
```
