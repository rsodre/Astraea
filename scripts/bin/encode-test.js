#!/usr/bin/env node
import { encodeBase64 , encodeBase64_padded , decodeBase64 } from './lib_decoder.js';

async function _encodeTest(input) {
  const encoded_1 = encodeBase64(input);
  const encoded_2 = encodeBase64_padded(input);
  const decoded_1 = decodeBase64(encoded_1);
  const decoded_2 = decodeBase64(encoded_2);
  console.log(`-------: [${input}]`, input.length);
  console.log(`encoded: [${encoded_1}]`, encoded_1.length);
  console.log(`decoded: [${decoded_1}]`, decoded_1.length);
  console.log(`encoded: [${encoded_2}]`, encoded_2.length);
  console.log(`decoded: [${decoded_2}]`, decoded_2.length);
}

_encodeTest('A');
_encodeTest('A ');
_encodeTest('A  ');


// _encodeTest('AB');
// _encodeTest('ABC');
// _encodeTest('ABCD');
