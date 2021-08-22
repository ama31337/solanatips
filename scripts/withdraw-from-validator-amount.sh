#!/bin/bash

# input vars
VOTE_KEY_NAME="vote-account-keypair.json"
VAL_KEY_NAME="validator-keypair.json"
#amount num or ALL
AMOUNT=$1

WALLET=$(cat $HOME/keys/rewards.addr)

# calc vars
SCRIPT_DIR=`cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P`
APP_SOLANA=`which solana`
APP_SOLANA_KEYGEN=`which solana-keygen`
VAL_KEYS_PATH=$(find $HOME -iname ${VAL_KEY_NAME} | head -n 1)
VAL_PUBKEY=`${APP_SOLANA_KEYGEN} pubkey ${VAL_KEYS_PATH}`



echo "Let's withdraw $AMOUNT SOL to $WALLET"
$APP_SOLANA transfer -k ${VAL_KEYS_PATH} --url http://127.0.0.1:8899 $WALLET $AMOUNT --allow-unfunded-recipient
echo "DONE"
