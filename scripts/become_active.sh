#!/bin/bash

SCRIPT_DIR=`cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P`
BIN_PATH="$HOME/.local/share/solana/install/active_release/bin"

${BIN_PATH}/solana-validator -l ${LEDGER_PATH} set-identity --require-tower ${HOME}/keys/validator-keypair.json

ln -sf ${HOME}/keys/validator-keypair.json ${HOME}/keys/identity.json
