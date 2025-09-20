#!/bin/bash
set -euo pipefail
source scripts/setup.sh

if [ $# -ge 2 ]; then
  export RECIPIENT_ADDRESS=$2
else
  # export PROFILE="dev"
  echo "usage: $0 <PROFILE> <RECIPIENT_ADDRESS>"
  exit 1
fi

# move down to /dojo
pushd $(dirname "$0")/..

# sozo execute --world <WORLD_ADDRESS> <CONTRACT> <ENTRYPOINT>
echo "> minting to: $RECIPIENT_ADDRESS"
echo sozo -P $PROFILE execute aster-minter --world $WORLD_ADDRESS --wait mint_to $RECIPIENT_ADDRESS
