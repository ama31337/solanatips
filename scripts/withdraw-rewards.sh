#!/bin/bash

# input vars
VOTE_KEY_NAME="vote-account-keypair.json"
VAL_KEY_NAME="validator-keypair.json"
#amount num or ALL
AMOUNT="1"
VOTE_MIN_BALANCE="5"

WALLET=$(cat $HOME/keys/rewards.addr)

# calc vars
SCRIPT_DIR=`cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P`
APP_SOLANA=`which solana`
APP_SOLANA_KEYGEN=`which solana-keygen`
VOTE_KEYS_PATH=$(find $HOME -iname ${VOTE_KEY_NAME} | head -n 1)
VAL_KEYS_PATH=$(find $HOME -iname ${VAL_KEY_NAME} | head -n 1)
VOTE_PUBKEY=`${APP_SOLANA_KEYGEN} pubkey ${VOTE_KEYS_PATH}`
VAL_PUBKEY=`${APP_SOLANA_KEYGEN} pubkey ${VAL_KEYS_PATH}`

VOTE_BALANCE=$($APP_SOLANA balance -k ${VOTE_KEYS_PATH} | awk '{print $1}')
VOTE_BALANCE=$(bc -l <<< "$VOTE_BALANCE - $VOTE_MIN_BALANCE")
#VOTE_BALANCE=${AMOUNT}


$APP_SOLANA withdraw-from-vote-account ${VOTE_PUBKEY} ${VAL_PUBKEY} ${VOTE_BALANCE} --authorized-withdrawer ${VOTE_KEYS_PATH} --url http://127.0.0.1:8899

sleep 15

echo -e "Vote Balance: $VOTE_BALANCE"
    if [[ $(bc -l <<< "$VOTE_BALANCE>1") -eq 1 ]]; then
        echo "Let's withdraw $VOTE_BALANCE of REWARD tokens"
        $APP_SOLANA transfer -k ${VAL_KEYS_PATH} --url http://127.0.0.1:8899 $WALLET $VOTE_BALANCE 
    else
        echo "Reward is $VOTE_BALANCE"
    fi
echo "DONE"
