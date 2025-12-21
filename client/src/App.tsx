import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { Flex, Text, Button, Grid, Box, Inset, Card, AspectRatio, Link, Heading, Spinner, Badge, Separator } from '@radix-ui/themes'
import { useAccount, useBlockNumber } from '@starknet-react/core';
import { useDojoSDK } from '@dojoengine/sdk/react';
import { WalletAccount } from './wallet-account';
import { SchemaType } from './generated/typescript/models.gen';
// import * as torii from "@dojoengine/torii-wasm";
// import { getContractByName } from '@dojoengine/core';
// import manifest from './generated/manifest_dev.json';

export default function App() {
  const { sdk, client } = useDojoSDK<() => any, SchemaType>();
  const { account, isConnected } = useAccount();
  const { data: blockNumber } = useBlockNumber({
    refetchInterval: 1000,
  });

  const [totalSupply, setTotalSupply] = useState(0);
  useEffect(() => {
    if (client) {
      console.log("Getting total supply...");
      client.token.totalSupply().then((totalSupply: number) => {
        setTotalSupply(Number(totalSupply));
      });
    }
  }, [client, blockNumber]);

  const _mint = useCallback(() => {
    if (client && account) {
      console.log("Minting...");
      client.minter.mint(account);
    }
  }, [client, account]);

  // useEffect(() => {
  //   if (sdk) {
  //     const contractAddresses = getContractByName(manifest, 'aster', 'token').address;
  //     sdk.getTokens({
  //       contractAddresses: [contractAddresses],
  //     }).then((tokens) => {
  //       console.log(tokens);
  //     });
  //   }
  // }, [sdk]);

  const [contractMode, setContractMode] = useState(true);
  const [tokenId, setTokenId] = useState(0);
  useEffect(() => {
    setContractMode(tokenId == 0);
  }, [tokenId]);

  const items = useMemo(() => {
    return new Array(totalSupply).fill(0).map((_, index) => <TokenImage key={index} tokenId={index + 1} setTokenId={setTokenId} />);
  }, [totalSupply]);

  return (
    <Flex direction='row' gap='2' width='100%'>
      <Grid columns='6' gap='2' width='auto' style={{ width: '50%' }}>
        {items}
        <Box width='100%' >
          <Button disabled={!isConnected} onClick={_mint} style={{ width: '100%' }}>Mint</Button>
        </Box>
      </Grid>
      <Box width='50%'>
        <WalletAccount />
        <Separator size="4" my="3" />
        <Text>
          block [{blockNumber}] minted [{totalSupply}]
        </Text>
        <Separator size="4" my="3" />
        <Flex direction='row' gap='2' m='2'>
          <Button variant={contractMode ? 'solid' : 'soft'} onClick={() => setContractMode(true)}>Contract</Button>
          <Button variant={!contractMode ? 'solid' : 'soft'} onClick={() => setContractMode(false)} disabled={!tokenId}>Token #{tokenId}</Button>
        </Flex>
        {contractMode && <ContractInfo />}
        {!contractMode && <TokenInfo tokenId={tokenId} />}
      </Box>
    </Flex>
  )
}




//-----------------------------------
// Contract metadata
//
const ContractInfo = () => {
  const { client } = useDojoSDK<() => any, SchemaType>();
  const [uri, setUri] = useState<string>();
  useEffect(() => {
    client?.token.contractUri().then((uri: string) => {
      setUri(uri);
    });
  }, [client]);
  const { json, isJsonValid, isUriValid } = useUri(uri);
  return (
    <Box>
      <UriStatus isUriValid={isUriValid} isJsonValid={isJsonValid} />
      <Text>symbol: [{json?.symbol}]</Text><br />
      <Text>name: [{json?.name}]</Text><br />
      <Text>description: [{json?.description}]</Text><br />
      <Text>external_link: [<Link href={json?.external_link} target='_blank'>{json?.external_link}</Link>]</Text><br />

      <Metadata json={json} />

      <Flex direction='row' gap='2'>
        <Box style={{ width: '50%' }}>
          <Image src={json?.image} label={`IMAGE`} />
        </Box>
        <Box style={{ width: '50%' }}>
          <Image src={json?.banner_image} label={`BANNER`} />
        </Box>
      </Flex>
    </Box>
  );
};

const useUri = (uri: string | undefined) => {
  const [isUriValid, setIsUriValid] = useState<boolean | undefined>(false);
  const [isJsonValid, setIsJsonValid] = useState<boolean | undefined>(false);
  const [json, setJson] = useState<any | undefined>(undefined);
  useEffect(() => {
    setIsUriValid(undefined);
    setIsJsonValid(undefined);
    setJson(undefined);
    if (uri) {
      try {
        const url = new URL(uri);
        setIsUriValid(true);
      } catch (error) {
        console.error(`INVALID URL:`, uri, error);
        setIsUriValid(false);
      }
      try {
        const json = JSON.parse(uri.replace('data:application/json,', ''));
        setJson(json);
        setIsJsonValid(true);
      } catch (error) {
        console.error(`INVALID JSON:`, uri, error);
        setIsJsonValid(false);
      }
    }
  }, [uri]);
  return {
    uri,
    isUriValid,
    isJsonValid,
    json,
  }
};

const UriStatus = ({
  isUriValid,
  isJsonValid,
}: {
  isUriValid: boolean | undefined,
  isJsonValid: boolean | undefined,
}) => {
  return (
    <Flex direction='row' gap='2'>
      <Badge color={isUriValid === undefined ? 'orange' : isUriValid === true ? 'green' : 'red'}>uri</Badge>
      <Badge color={isJsonValid === undefined ? 'orange' : isJsonValid === true ? 'green' : 'red'}>json</Badge>
    </Flex>
  );
};

const Metadata = ({
  json,
}: {
  json: any,
}) => {
  return (
    <Text size='1'>
      <pre style={{ overflowX: 'auto', backgroundColor: 'var(--gray-5)' }}>
        {JSON.stringify(json, null, 2)}
      </pre>
    </Text>
  );
};



//-----------------------------------
// Token #XX Image
//
const TokenInfo = ({
  tokenId,
}: {
  tokenId: number,
}) => {
  const { client } = useDojoSDK<() => any, SchemaType>();
  const [uri, setUri] = useState<string>();
  useEffect(() => {
    client?.token.tokenUri(tokenId).then((uri: string) => {
      setUri(uri);
    });
  }, [client, tokenId]);
  const { json, isJsonValid, isUriValid } = useUri(uri);
  if (!json) return <Spinner />;
  return (
    <Box>
      <UriStatus isUriValid={isUriValid} isJsonValid={isJsonValid} />
      <Text>name: [{json?.name}]</Text><br />
      <Text>description: [{json?.description}]</Text><br />
      <Image src={json?.image} label={json?.name} tokenId={tokenId} />
      <Metadata json={json} />
    </Box>
  );
};

const TokenImage = ({
  tokenId,
  setTokenId,
}: {
  tokenId: number,
  setTokenId?: (tokenId: number) => void
}) => {
  const { client } = useDojoSDK<() => any, SchemaType>();
  const [uri, setUri] = useState<string>();
  useEffect(() => {
    client?.token.tokenUri(tokenId).then((uri: string) => {
      setUri(uri);
    });
  }, [client, tokenId]);
  const { json, isJsonValid, isUriValid } = useUri(uri);
  if (!json) return <Spinner />;
  return (
    <Image src={json?.image} label={json?.name} tokenId={tokenId} setTokenId={setTokenId}>
      <UriStatus isUriValid={isUriValid} isJsonValid={isJsonValid} />
    </Image>
  );
};


//-----------------------------------
// Generic Image
//
const Image = ({
  src,
  label,
  tokenId,
  setTokenId,
  width = 'auto',
  height = '100%',
  children,
}: {
  src: string,
  label: string,
  tokenId?: number,
  setTokenId?: (tokenId: number) => void
  width?: string,
  height?: string,
  children?: React.ReactNode,
}) => {
  return (
    <Box>
      <Flex direction='column' gap='2'>
        <AspectRatio ratio={1}>
          <img src={src}
            style={{
              width,
              height,
              backgroundColor: "var(--gray-5)",
              cursor: setTokenId ? "pointer" : "default",
            }}
            onClick={() => setTokenId?.(tokenId ?? 0)}
          />
        </AspectRatio>
        <Text size='1' color='gray'>{label}</Text>
        {children}
      </Flex>
    </Box>
  );
};