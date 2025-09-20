# 2025-09-20 / sepolia

```
$ date
Sat Sep 20 14:45:58 -03 2025

$ ./migrate sepolia          
:sepolia
get_profile_env(world_block) not found! 👎
------------------------------------------------------------------------------
Profile    : sepolia
Project    : Aster (Starktember 2025)
PC Url     : https://api.cartridge.gg/x/starknet/sepolia
Chain Id   : SN_SEPOLIA
World      : 0x7774946aab21c0b2b2484aa9a6f03bb64fd33550bb2cc8b22d46922b49af17c
Account    : 0x020dD2C29473df564F9735B7c16063Eb3B7A4A3bd70a7986526636Fe33E8227d
::token    : 0x70ea289f608f37e2ee38e8a5a5e1cd9203e7666db36714d20382b73302308e5
::minter   : 0x1795a40c0b3838406a359fcc5ff9dc1cd90505a1da3b0b6f8a8b192da3a9966
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
🚦 execute: sozo -P sepolia  clean
>>> Building...
🚦 execute: sozo -P sepolia  build
warn: in context of a workspace, only the `profile` set in the workspace manifest is applied,
but the `example` package also defines `profile` in the manifest

   Compiling dojo_macros v1.7.0-alpha.4 (git+https://github.com/dojoengine/dojo?tag=v1.7.0-alpha.4#7b78108ce7aea7753c0a9e34cb83465a76bbf2e4)
    Finished `release` profile [optimized] target(s) in 0.26s
   Compiling aster v1.0.0 (/Users/roger/Dev/Realms/ASTER/dojo/Scarb.toml)
warn[E0001]: Unused variable. Consider ignoring by prefixing with `_`.
 --> /Users/roger/Dev/Realms/ASTER/dojo/src/systems/renderer.cairo:24:13
        let palette_styles: ByteArray = props.palette.get_styles();
            ^^^^^^^^^^^^^^

warn[E0001]: Unused variable. Consider ignoring by prefixing with `_`.
 --> /Users/roger/Dev/Realms/ASTER/dojo/src/systems/renderer.cairo:26:13
        let density: usize = props.density;
            ^^^^^^^

warn[E0001]: Unused variable. Consider ignoring by prefixing with `_`.
 --> /Users/roger/Dev/Realms/ASTER/dojo/src/systems/renderer.cairo:25:13
        let distribution: Distribution = props.distribution;
            ^^^^^^^^^^^^

    Finished `sepolia` profile target(s) in 11 seconds
👍
------------------------------------------------------------------------------
>>> Inspect migrations...
🚦 execute: sozo -P sepolia  inspect --world 0x7774946aab21c0b2b2484aa9a6f03bb64fd33550bb2cc8b22d46922b49af17c

 World   | Contract Address                                                   | Class Hash                                                         
---------+--------------------------------------------------------------------+--------------------------------------------------------------------
 Created | 0x07774946aab21c0b2b2484aa9a6f03bb64fd33550bb2cc8b22d46922b49af17c | 0x057994b6a75fad550ca18b41ee82e2110e158c59028c4478109a67965a0e5b1e 

 Namespaces | Status  | Dojo Selector                                                      
------------+---------+--------------------------------------------------------------------
 aster      | Created | 0x0513f1fe0356a70aa9aa6a232dbff898ce666c7b8926fe5a133986df22f17000 

 Contracts    | Status  | Is Initialized | Dojo Selector                                                      | Contract Address                                                   
--------------+---------+----------------+--------------------------------------------------------------------+--------------------------------------------------------------------
 aster-minter | Created | false          | 0x036eac7d7164bd0a40a0f4e02091aabf72c6ecea97cff8f2b10240f848610f8d | 0x0367446f5d80a4455608bc8806c9c918c3a10eff2d538b07289a3e3c6226c844 
 aster-token  | Created | false          | 0x04bb82dc1d2634f44aa08ce225e71a4909c42834710a7c46df06ec0120143a34 | 0x05bb54b047419c975c3be4e2cd5ad3df6084f5df96008182c214a78bd694f61e 

 Models            | Status  | Dojo Selector                                                      
-------------------+---------+--------------------------------------------------------------------
 aster-Seed        | Created | 0x032603ae72eea61056fed2e38e5ff52b4c5e458e1352bd06523243c011e4956d 
 aster-TokenConfig | Created | 0x06649cfa36f3ab516b4e7b10b58a47efe4bc1c3b6706a170c3e7f86c4b80dde6 

 Events                 | Status  | Dojo Selector                                                      
------------------------+---------+--------------------------------------------------------------------
 aster-TokenBurnedEvent | Created | 0x051377a8e2d9dadf4e7edb78bfc06ec12b9855a396706556ca0b5cc16184e2f0 
 aster-TokenMintedEvent | Created | 0x057b7e43cf043309f0dfc74e052929aa1eb82717dd4dc4dd513c334bc0406b8d 

>>> Do migrations...
🚦 execute: sozo -P sepolia  migrate --world 0x7774946aab21c0b2b2484aa9a6f03bb64fd33550bb2cc8b22d46922b49af17c 

 profile | chain_id   | rpc_url                                     
---------+------------+---------------------------------------------
 sepolia | SN_SEPOLIA | https://api.cartridge.gg/x/starknet/sepolia 

                                 
🌍 World deployed at block PRE CONFIRMED (2148277) with txn hash: 0x00258923fa8119bd1b9679037ef5eb42e8f101c44443dc48de8b56269bb17782
🥷  Initializing 2 contracts...     
IPFS credentials not found. Metadata upload skipped. To upload metadata, configure IPFS credentials in your profile config or environment variables: https://book.dojoengine.org/framework/world/metadata.
⛩️  Migration successful with world at address 0x07774946aab21c0b2b2484aa9a6f03bb64fd33550bb2cc8b22d46922b49af17c
👍
------------------------------------------------------------------------------
>>> Copying manifest [./manifest_sepolia.json] to [../client/src/generated/]
total 336
-rw-r--r--@ 1 roger  staff  84487 Sep 20 14:15 manifest_dev.json
-rw-r--r--@ 1 roger  staff  84552 Sep 20 14:30 manifest_sepolia.json
drwxr-xr-x@ 4 roger  staff    128 Sep 14 15:07 typescript
👍
--- DONE! 👍
```
