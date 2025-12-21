#!/bin/bash
set -e # exit on error

export NETWORK="mainnet"
export NAMESPACE="aster"

export SCARB_PROJECT_PATH="../dojo"
export MANIFEST_FILE_PATH="../dojo/manifest_$NETWORK.json"

get_contract_class_hash () {
  local CONTRACT_NAME=$1
  local TAG="$NAMESPACE-$CONTRACT_NAME"
  local RESULT=$(cat $MANIFEST_FILE_PATH | jq -r ".contracts[] | select(.tag == \"$TAG\" ).class_hash")
  if [[ -z "$RESULT" ]]; then # if not set
    >&2 echo "get_contract_class_hash($TAG) not found! 👎"
  fi
  echo $RESULT
}

execute_command () {
  local COMMAND=$1
  echo "🚦 execute: $COMMAND"
  $COMMAND
}

verify_contract () {
  # voyager verify --help
  # exit 1

  # find contract address
  local CONTRACT_NAME=$1
  export CLASS_HASH=$(get_contract_class_hash "$CONTRACT_NAME")
  echo ">>> [$CONTRACT_NAME] class_hash:[$CLASS_HASH]"
  if [[ -z "$CLASS_HASH" ]]; then # if not set
    echo "❌ Missing class hash! 👎"
    exit 1
  fi
  
  # verify
  execute_command "voyager verify --network $NETWORK --contract-name $CONTRACT_NAME --class-hash $CLASS_HASH --path $SCARB_PROJECT_PATH --license CC0-1.0 --lock-file --watch --verbose"
}

#-----------------
# verify
#
voyager --version
verify_contract "minter"
verify_contract "token"
