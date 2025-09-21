#!/usr/bin/env node
import { encodeBase64 } from './lib_decoder.js';
import fs from 'fs';

//
// base64: 3 chars = 4 bytes
//

const _encode = (input_path) => {
  let svg = fs.readFileSync(input_path, 'utf8');
  // remove newlines
  svg = svg.replaceAll('\n', '');
  console.log(`svg: [${svg}]`, svg.length);
  // encode padded
  const encoded = encodeBase64(svg);
  fs.writeFileSync(`${input_path}.txt`, encoded);

  // remove newlines
  console.log(`encoded: [${encoded}]`, encoded.length);
}

_encode('../drafts/contract_banner.svg');
_encode('../drafts/contract_image.svg');
