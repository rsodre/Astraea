#!/usr/bin/env node
import { encodeBase64_padded } from './lib_decoder.js';
import fs from 'fs';

//
// base64: 3 chars = 4 bytes
// 

const input_path = '../drafts/defs.svg';
const output_path = '../drafts/defs.svg.txt';

// remove newlines
let defs = fs.readFileSync(input_path, 'utf8');
// remove newlines
defs = defs.replaceAll('\n', '');
console.log(`defs: [${defs}]`, defs.length);
// encode padded
const encoded = encodeBase64_padded(defs);
fs.writeFileSync(output_path, encoded);
console.log(`encoded: [${encoded}]`, encoded.length);

if (encoded.at(encoded.length - 1) == '=') {
  console.error('>>> ERROR!!! encoded not padded!!!');
}