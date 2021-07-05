#!/bin/bash

# input vars
VOTE_KEY_NAME="vote-account-keypair.json"
VAL_KEY_NAME="validator-keypair.json"
#amount num or ALL
AMOUNT="10"
VOTE_MIN_BALANCE="5"

# calc vars
SCRIPT_DIR=`cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P`
APP_SOLANA=`which solana`
APP_SOLANA_KEYGEN=`which solana-keygen`
VOTE_KEYS_PATH=$(find $HOME -iname ${VOTE_KEY_NAME} | head -n 1)
VAL_KEYS_PATH=$(find $HOME -iname ${VAL_KEY_NAME} | head -n 1)
VOTE_PUBKEY=`${APP_SOLANA_KEYGEN} pubkey ${VOTE_KEYS_PATH}`
VAL_PUBKEY=`${APP_SOLANA_KEYGEN} pubkey ${VAL_KEYS_PATH}`

VOTE_BALANCE=$($APP_SOLANA balance -k ${VOTE_KEYS_PATH} | awk '{print $1}')
VAL_BALANCE=$($APP_SOLANA balance -k ${VAL_KEYS_PATH} | awk '{print $1}')
#VOTE_BALANCE=${AMOUNT}
echo "vote balance: $VOTE_BALANCE"
echo "validator balance: $VAL_BALANCE"

VOTE_BALANCE=$(bc -l <<< "$VOTE_BALANCE - $VOTE_MIN_BALANCE ")
echo "balance to withdraw: $VOTE_BALANCE"
