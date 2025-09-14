import { DojoProvider, DojoCall } from "@dojoengine/core";
import { Account, AccountInterface, BigNumberish, CairoOption, CairoCustomEnum } from "starknet";
import * as models from "./models.gen";

export function setupWorld(provider: DojoProvider) {

	const build_minter_canMint_calldata = (recipient: string): DojoCall => {
		return {
			contractName: "minter",
			entrypoint: "can_mint",
			calldata: [recipient],
		};
	};

	const minter_canMint = async (recipient: string) => {
		try {
			return await provider.call("aster", build_minter_canMint_calldata(recipient));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_minter_getPrice_calldata = (): DojoCall => {
		return {
			contractName: "minter",
			entrypoint: "get_price",
			calldata: [],
		};
	};

	const minter_getPrice = async () => {
		try {
			return await provider.call("aster", build_minter_getPrice_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_minter_mint_calldata = (): DojoCall => {
		return {
			contractName: "minter",
			entrypoint: "mint",
			calldata: [],
		};
	};

	const minter_mint = async (snAccount: Account | AccountInterface) => {
		try {
			return await provider.execute(
				snAccount,
				build_minter_mint_calldata(),
				"aster",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_minter_mintTo_calldata = (recipient: string): DojoCall => {
		return {
			contractName: "minter",
			entrypoint: "mint_to",
			calldata: [recipient],
		};
	};

	const minter_mintTo = async (snAccount: Account | AccountInterface, recipient: string) => {
		try {
			return await provider.execute(
				snAccount,
				build_minter_mintTo_calldata(recipient),
				"aster",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_minter_setPurchasePrice_calldata = (purchaseCoinAddress: string, purchasePriceEth: BigNumberish): DojoCall => {
		return {
			contractName: "minter",
			entrypoint: "set_purchase_price",
			calldata: [purchaseCoinAddress, purchasePriceEth],
		};
	};

	const minter_setPurchasePrice = async (snAccount: Account | AccountInterface, purchaseCoinAddress: string, purchasePriceEth: BigNumberish) => {
		try {
			return await provider.execute(
				snAccount,
				build_minter_setPurchasePrice_calldata(purchaseCoinAddress, purchasePriceEth),
				"aster",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_approve_calldata = (to: string, tokenId: BigNumberish): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "approve",
			calldata: [to, tokenId],
		};
	};

	const token_approve = async (snAccount: Account | AccountInterface, to: string, tokenId: BigNumberish) => {
		try {
			return await provider.execute(
				snAccount,
				build_token_approve_calldata(to, tokenId),
				"aster",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_availableSupply_calldata = (): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "availableSupply",
			calldata: [],
		};
	};

	const token_availableSupply = async () => {
		try {
			return await provider.call("aster", build_token_availableSupply_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_balanceOf_calldata = (account: string): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "balanceOf",
			calldata: [account],
		};
	};

	const token_balanceOf = async (account: string) => {
		try {
			return await provider.call("aster", build_token_balanceOf_calldata(account));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_burn_calldata = (tokenId: BigNumberish): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "burn",
			calldata: [tokenId],
		};
	};

	const token_burn = async (snAccount: Account | AccountInterface, tokenId: BigNumberish) => {
		try {
			return await provider.execute(
				snAccount,
				build_token_burn_calldata(tokenId),
				"aster",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_contractUri_calldata = (): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "contractURI",
			calldata: [],
		};
	};

	const token_contractUri = async () => {
		try {
			return await provider.call("aster", build_token_contractUri_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_defaultRoyalty_calldata = (): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "defaultRoyalty",
			calldata: [],
		};
	};

	const token_defaultRoyalty = async () => {
		try {
			return await provider.call("aster", build_token_defaultRoyalty_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_getApproved_calldata = (tokenId: BigNumberish): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "getApproved",
			calldata: [tokenId],
		};
	};

	const token_getApproved = async (tokenId: BigNumberish) => {
		try {
			return await provider.call("aster", build_token_getApproved_calldata(tokenId));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_getTokenSvg_calldata = (tokenId: BigNumberish): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "get_token_svg",
			calldata: [tokenId],
		};
	};

	const token_getTokenSvg = async (snAccount: Account | AccountInterface, tokenId: BigNumberish) => {
		try {
			return await provider.execute(
				snAccount,
				build_token_getTokenSvg_calldata(tokenId),
				"aster",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_isApprovedForAll_calldata = (owner: string, operator: string): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "isApprovedForAll",
			calldata: [owner, operator],
		};
	};

	const token_isApprovedForAll = async (owner: string, operator: string) => {
		try {
			return await provider.call("aster", build_token_isApprovedForAll_calldata(owner, operator));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_isMintedOut_calldata = (): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "is_minted_out",
			calldata: [],
		};
	};

	const token_isMintedOut = async () => {
		try {
			return await provider.call("aster", build_token_isMintedOut_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_isMintingPaused_calldata = (): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "is_minting_paused",
			calldata: [],
		};
	};

	const token_isMintingPaused = async () => {
		try {
			return await provider.call("aster", build_token_isMintingPaused_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_isOwnerOf_calldata = (address: string, tokenId: BigNumberish): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "is_owner_of",
			calldata: [address, tokenId],
		};
	};

	const token_isOwnerOf = async (address: string, tokenId: BigNumberish) => {
		try {
			return await provider.call("aster", build_token_isOwnerOf_calldata(address, tokenId));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_lastTokenId_calldata = (): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "last_token_id",
			calldata: [],
		};
	};

	const token_lastTokenId = async () => {
		try {
			return await provider.call("aster", build_token_lastTokenId_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_maxSupply_calldata = (): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "maxSupply",
			calldata: [],
		};
	};

	const token_maxSupply = async () => {
		try {
			return await provider.call("aster", build_token_maxSupply_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_mintNext_calldata = (recipient: string): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "mint_next",
			calldata: [recipient],
		};
	};

	const token_mintNext = async (snAccount: Account | AccountInterface, recipient: string) => {
		try {
			return await provider.execute(
				snAccount,
				build_token_mintNext_calldata(recipient),
				"aster",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_mintedSupply_calldata = (): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "mintedSupply",
			calldata: [],
		};
	};

	const token_mintedSupply = async () => {
		try {
			return await provider.call("aster", build_token_mintedSupply_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_name_calldata = (): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "name",
			calldata: [],
		};
	};

	const token_name = async () => {
		try {
			return await provider.call("aster", build_token_name_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_ownerOf_calldata = (tokenId: BigNumberish): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "ownerOf",
			calldata: [tokenId],
		};
	};

	const token_ownerOf = async (tokenId: BigNumberish) => {
		try {
			return await provider.call("aster", build_token_ownerOf_calldata(tokenId));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_reservedSupply_calldata = (): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "reservedSupply",
			calldata: [],
		};
	};

	const token_reservedSupply = async () => {
		try {
			return await provider.call("aster", build_token_reservedSupply_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_royaltyInfo_calldata = (tokenId: BigNumberish, salePrice: BigNumberish): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "royaltyInfo",
			calldata: [tokenId, salePrice],
		};
	};

	const token_royaltyInfo = async (tokenId: BigNumberish, salePrice: BigNumberish) => {
		try {
			return await provider.call("aster", build_token_royaltyInfo_calldata(tokenId, salePrice));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_safeTransferFrom_calldata = (from: string, to: string, tokenId: BigNumberish, data: Array<BigNumberish>): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "safeTransferFrom",
			calldata: [from, to, tokenId, data],
		};
	};

	const token_safeTransferFrom = async (snAccount: Account | AccountInterface, from: string, to: string, tokenId: BigNumberish, data: Array<BigNumberish>) => {
		try {
			return await provider.execute(
				snAccount,
				build_token_safeTransferFrom_calldata(from, to, tokenId, data),
				"aster",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_setApprovalForAll_calldata = (operator: string, approved: boolean): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "setApprovalForAll",
			calldata: [operator, approved],
		};
	};

	const token_setApprovalForAll = async (snAccount: Account | AccountInterface, operator: string, approved: boolean) => {
		try {
			return await provider.execute(
				snAccount,
				build_token_setApprovalForAll_calldata(operator, approved),
				"aster",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_setPaused_calldata = (isPaused: boolean): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "set_paused",
			calldata: [isPaused],
		};
	};

	const token_setPaused = async (snAccount: Account | AccountInterface, isPaused: boolean) => {
		try {
			return await provider.execute(
				snAccount,
				build_token_setPaused_calldata(isPaused),
				"aster",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_setReservedSupply_calldata = (reservedSupply: BigNumberish): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "set_reserved_supply",
			calldata: [reservedSupply],
		};
	};

	const token_setReservedSupply = async (snAccount: Account | AccountInterface, reservedSupply: BigNumberish) => {
		try {
			return await provider.execute(
				snAccount,
				build_token_setReservedSupply_calldata(reservedSupply),
				"aster",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_supportsInterface_calldata = (interfaceId: BigNumberish): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "supports_interface",
			calldata: [interfaceId],
		};
	};

	const token_supportsInterface = async (interfaceId: BigNumberish) => {
		try {
			return await provider.call("aster", build_token_supportsInterface_calldata(interfaceId));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_symbol_calldata = (): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "symbol",
			calldata: [],
		};
	};

	const token_symbol = async () => {
		try {
			return await provider.call("aster", build_token_symbol_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_tokenRoyalty_calldata = (tokenId: BigNumberish): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "tokenRoyalty",
			calldata: [tokenId],
		};
	};

	const token_tokenRoyalty = async (tokenId: BigNumberish) => {
		try {
			return await provider.call("aster", build_token_tokenRoyalty_calldata(tokenId));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_tokenUri_calldata = (tokenId: BigNumberish): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "tokenURI",
			calldata: [tokenId],
		};
	};

	const token_tokenUri = async (tokenId: BigNumberish) => {
		try {
			return await provider.call("aster", build_token_tokenUri_calldata(tokenId));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_tokenExists_calldata = (tokenId: BigNumberish): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "token_exists",
			calldata: [tokenId],
		};
	};

	const token_tokenExists = async (tokenId: BigNumberish) => {
		try {
			return await provider.call("aster", build_token_tokenExists_calldata(tokenId));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_totalSupply_calldata = (): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "totalSupply",
			calldata: [],
		};
	};

	const token_totalSupply = async () => {
		try {
			return await provider.call("aster", build_token_totalSupply_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_transferFrom_calldata = (from: string, to: string, tokenId: BigNumberish): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "transferFrom",
			calldata: [from, to, tokenId],
		};
	};

	const token_transferFrom = async (snAccount: Account | AccountInterface, from: string, to: string, tokenId: BigNumberish) => {
		try {
			return await provider.execute(
				snAccount,
				build_token_transferFrom_calldata(from, to, tokenId),
				"aster",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_updateContractMetadata_calldata = (): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "update_contract_metadata",
			calldata: [],
		};
	};

	const token_updateContractMetadata = async (snAccount: Account | AccountInterface) => {
		try {
			return await provider.execute(
				snAccount,
				build_token_updateContractMetadata_calldata(),
				"aster",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_updateTokenMetadata_calldata = (tokenId: BigNumberish): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "update_token_metadata",
			calldata: [tokenId],
		};
	};

	const token_updateTokenMetadata = async (snAccount: Account | AccountInterface, tokenId: BigNumberish) => {
		try {
			return await provider.execute(
				snAccount,
				build_token_updateTokenMetadata_calldata(tokenId),
				"aster",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_token_updateTokensMetadata_calldata = (fromTokenId: BigNumberish, toTokenId: BigNumberish): DojoCall => {
		return {
			contractName: "token",
			entrypoint: "update_tokens_metadata",
			calldata: [fromTokenId, toTokenId],
		};
	};

	const token_updateTokensMetadata = async (snAccount: Account | AccountInterface, fromTokenId: BigNumberish, toTokenId: BigNumberish) => {
		try {
			return await provider.execute(
				snAccount,
				build_token_updateTokensMetadata_calldata(fromTokenId, toTokenId),
				"aster",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};



	return {
		minter: {
			canMint: minter_canMint,
			buildCanMintCalldata: build_minter_canMint_calldata,
			getPrice: minter_getPrice,
			buildGetPriceCalldata: build_minter_getPrice_calldata,
			mint: minter_mint,
			buildMintCalldata: build_minter_mint_calldata,
			mintTo: minter_mintTo,
			buildMintToCalldata: build_minter_mintTo_calldata,
			setPurchasePrice: minter_setPurchasePrice,
			buildSetPurchasePriceCalldata: build_minter_setPurchasePrice_calldata,
		},
		token: {
			approve: token_approve,
			buildApproveCalldata: build_token_approve_calldata,
			availableSupply: token_availableSupply,
			buildAvailableSupplyCalldata: build_token_availableSupply_calldata,
			balanceOf: token_balanceOf,
			buildBalanceOfCalldata: build_token_balanceOf_calldata,
			burn: token_burn,
			buildBurnCalldata: build_token_burn_calldata,
			contractUri: token_contractUri,
			buildContractUriCalldata: build_token_contractUri_calldata,
			defaultRoyalty: token_defaultRoyalty,
			buildDefaultRoyaltyCalldata: build_token_defaultRoyalty_calldata,
			getApproved: token_getApproved,
			buildGetApprovedCalldata: build_token_getApproved_calldata,
			getTokenSvg: token_getTokenSvg,
			buildGetTokenSvgCalldata: build_token_getTokenSvg_calldata,
			isApprovedForAll: token_isApprovedForAll,
			buildIsApprovedForAllCalldata: build_token_isApprovedForAll_calldata,
			isMintedOut: token_isMintedOut,
			buildIsMintedOutCalldata: build_token_isMintedOut_calldata,
			isMintingPaused: token_isMintingPaused,
			buildIsMintingPausedCalldata: build_token_isMintingPaused_calldata,
			isOwnerOf: token_isOwnerOf,
			buildIsOwnerOfCalldata: build_token_isOwnerOf_calldata,
			lastTokenId: token_lastTokenId,
			buildLastTokenIdCalldata: build_token_lastTokenId_calldata,
			maxSupply: token_maxSupply,
			buildMaxSupplyCalldata: build_token_maxSupply_calldata,
			mintNext: token_mintNext,
			buildMintNextCalldata: build_token_mintNext_calldata,
			mintedSupply: token_mintedSupply,
			buildMintedSupplyCalldata: build_token_mintedSupply_calldata,
			name: token_name,
			buildNameCalldata: build_token_name_calldata,
			ownerOf: token_ownerOf,
			buildOwnerOfCalldata: build_token_ownerOf_calldata,
			reservedSupply: token_reservedSupply,
			buildReservedSupplyCalldata: build_token_reservedSupply_calldata,
			royaltyInfo: token_royaltyInfo,
			buildRoyaltyInfoCalldata: build_token_royaltyInfo_calldata,
			safeTransferFrom: token_safeTransferFrom,
			buildSafeTransferFromCalldata: build_token_safeTransferFrom_calldata,
			setApprovalForAll: token_setApprovalForAll,
			buildSetApprovalForAllCalldata: build_token_setApprovalForAll_calldata,
			setPaused: token_setPaused,
			buildSetPausedCalldata: build_token_setPaused_calldata,
			setReservedSupply: token_setReservedSupply,
			buildSetReservedSupplyCalldata: build_token_setReservedSupply_calldata,
			supportsInterface: token_supportsInterface,
			buildSupportsInterfaceCalldata: build_token_supportsInterface_calldata,
			symbol: token_symbol,
			buildSymbolCalldata: build_token_symbol_calldata,
			tokenRoyalty: token_tokenRoyalty,
			buildTokenRoyaltyCalldata: build_token_tokenRoyalty_calldata,
			tokenUri: token_tokenUri,
			buildTokenUriCalldata: build_token_tokenUri_calldata,
			tokenExists: token_tokenExists,
			buildTokenExistsCalldata: build_token_tokenExists_calldata,
			totalSupply: token_totalSupply,
			buildTotalSupplyCalldata: build_token_totalSupply_calldata,
			transferFrom: token_transferFrom,
			buildTransferFromCalldata: build_token_transferFrom_calldata,
			updateContractMetadata: token_updateContractMetadata,
			buildUpdateContractMetadataCalldata: build_token_updateContractMetadata_calldata,
			updateTokenMetadata: token_updateTokenMetadata,
			buildUpdateTokenMetadataCalldata: build_token_updateTokenMetadata_calldata,
			updateTokensMetadata: token_updateTokensMetadata,
			buildUpdateTokensMetadataCalldata: build_token_updateTokensMetadata_calldata,
		},
	};
}