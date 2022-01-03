#!/bin/bash

# input vars
AMOUNT="10"
VAL_MIN_BALANCE="1"

# calc vars
SCRIPT_DIR=`cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P`
APP_SOLANA="/home/sol/.local/share/solana/install/active_release/bin/solana"
APP_SOLANA_KEYGEN="/home/sol/.local/share/solana/install/active_release/bin/solana-keygen"
VAL_KEYS_PATH="/home/sol/keys/validator-keypair.json"
VAL_PUBKEY=`${APP_SOLANA_KEYGEN} pubkey ${VAL_KEYS_PATH}`

VAL_BALANCE=$($APP_SOLANA balance -k ${VAL_KEYS_PATH} | awk '{print $1}')

echo -e "validator Balance: $VAL_BALANCE"
    if [[ $(bc -l <<< "$VAL_BALANCE < $VAL_MIN_BALANCE") -eq 1 ]]; then
        echo "ALARM! Validator Balance: $VAL_BALANCE is below limit! Refill to: $VAL_PUBKEY"
        "${SCRIPT_DIR}/Send_msg_toTelBot.sh" "$HOSTNAME inform you:" "ALARM! Validator Balance: $VAL_BALANCE is below limit! Refill to: $VAL_PUBKEY" 2>&1 > /dev/null
    else
        echo "ok"
    fi
echo "DONE"
