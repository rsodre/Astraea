import type { SchemaType as ISchemaType } from "@dojoengine/sdk";

import { BigNumberish } from 'starknet';

// Type definition for `aster::models::seed::Seed` struct
export interface Seed {
	token_id: BigNumberish;
	seed: BigNumberish;
}

// Type definition for `aster::models::token_config::TokenConfig` struct
export interface TokenConfig {
	token_address: string;
	treasury_address: string;
	purchase_coin_address: string;
	purchase_price_wei: BigNumberish;
	max_per_wallet: BigNumberish;
}

// Type definition for `aster::models::events::TokenBurnedEvent` struct
export interface TokenBurnedEvent {
	token_contract_address: string;
	token_id: BigNumberish;
	owner: string;
}

// Type definition for `aster::models::events::TokenMintedEvent` struct
export interface TokenMintedEvent {
	token_contract_address: string;
	token_id: BigNumberish;
	recipient: string;
	seed: BigNumberish;
}

export interface SchemaType extends ISchemaType {
	aster: {
		Seed: Seed,
		TokenConfig: TokenConfig,
		TokenBurnedEvent: TokenBurnedEvent,
		TokenMintedEvent: TokenMintedEvent,
	},
}
export const schema: SchemaType = {
	aster: {
		Seed: {
			token_id: 0,
			seed: 0,
		},
		TokenConfig: {
			token_address: "",
			treasury_address: "",
			purchase_coin_address: "",
			purchase_price_wei: 0,
			max_per_wallet: 0,
		},
		TokenBurnedEvent: {
			token_contract_address: "",
			token_id: 0,
			owner: "",
		},
		TokenMintedEvent: {
			token_contract_address: "",
			token_id: 0,
			recipient: "",
			seed: 0,
		},
	},
};
export enum ModelsMapping {
	Seed = 'aster-Seed',
	TokenConfig = 'aster-TokenConfig',
	TokenBurnedEvent = 'aster-TokenBurnedEvent',
	TokenMintedEvent = 'aster-TokenMintedEvent',
}