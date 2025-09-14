import { useEffect, useRef } from 'react';
import { Flex, Text, Button, Grid, Box } from '@radix-ui/themes'
import { useAccount } from '@starknet-react/core';
import { useDojoSDK } from '@dojoengine/sdk/react';
import { WalletAccount } from './wallet-account';
import * as torii from "@dojoengine/torii-wasm";

export default function App() {
  const { sdk } = useDojoSDK();
  const { account } = useAccount();


  // const subscriptionRef = useRef<torii.Subscription>(undefined);
  // useEffect(() => {
  //   async function setupSub() {
  //     if (subscriptionRef.current) return;
  //     const contractAddresses = [
  //       "0x044e6bcc627e6201ce09f781d1aae44ea4c21c2fdef299e34fce55bef2d02210",
  //       "0x02549653a4ae1ff8d04a20b8820a49cbe97486c536ec0e4c8f68aa33d80067cf",
  //       "0x068a7a07e08fc3e723a878223d00f669106780d5ea6665eb15d893476d47bf3b",
  //       "0x071333ac75b7d5ba89a2d0c2b67d5b955258a4d46eb42f3428da6137bbbfdfd9",
  //       "0x07aaa9866750a0db82a54ba8674c38620fa2f967d2fbb31133def48e0527c87f",
  //       "0x02e9c711b1a7e2784570b1bda5082a92606044e836ba392d2b977d280fb74b3c",
  //       "0x014aa76e6c6f11e3f657ee2c213a62006c78ff2c6f8ed40b92c42fd554c246f2",
  //     ];
  //     subscriptionRef.current = await sdk.onTokenBalanceUpdated({
  //       contractAddresses,
  //       accountAddresses: [],
  //       tokenIds: [],
  //       callback: ({ data }) => {
  //         console.log("Subscription dojo.c callback called");
  //         console.log(data);
  //       },
  //     });
  //     await sdk.subscribeEventQuery({
  //       query: new ToriiQueryBuilder().withClause(
  //         KeysClause([], [undefined], "VariableLen").build()
  //       ),
  //       callback: ({ data, error }) => {
  //         if (data) {
  //           console.log(data[0]);
  //         }
  //         if (error) {
  //           console.error(error);
  //         }
  //       },
  //     });
  //   }
  //   setupSub();
  //   return () => {
  //     if (subscriptionRef.current) {
  //       subscriptionRef.current.free();
  //     }
  //   };
  // }, [sdk]);

  return (
    <Flex direction='row' gap='2' width='100%'>
      <Grid columns='6' gap='2' rows='repeat(2, 64px)' width='auto' style={{ width: '50%' }}>
        <Button />
        <Button />
        <Button />
        <Button />
        <Button />
        <Button />
      </Grid>
      <Box width='50%'>
        <WalletAccount />
        <Text>
          yo!
        </Text>
      </Box>
    </Flex>
  )
}
