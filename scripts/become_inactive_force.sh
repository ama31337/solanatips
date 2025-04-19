#!/bin/bash

SCRIPT_DIR=`cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P`
BIN_PATH="$HOME/.local/share/solana/install/active_release/bin"

# Source the env.sh file on the local machine
source env.sh

# Set the local_test variable based on the value of TEST in env.sh
LOCAL_LEDGER=${LEDGER_PATH}

${BIN_PATH}/agave-validator -l ${LOCAL_LEDGER} set-identity ${HOME}/keys/unstaked-identity.json
ln -sf ${HOME}/keys/unstaked-identity.json ${HOME}/keys/identity.json

echo "done"
