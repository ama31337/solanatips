#!/bin/bash

# input vars
KEY_NAME="validator-keypair.json"
TIMEOUT=30

# calc vars
SCRIPT_DIR=`cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P`
APP_SOLANA=`which solana`
APP_SOLANA_KEYGEN=`which solana-keygen`
KEYS_PATH=$(find $HOME -iname ${KEY_NAME} | head -n 1)
ID_PUBKEY=`${APP_SOLANA_KEYGEN} pubkey ${KEYS_PATH}`


#VALIDATOR_ADDR="xxx"
VALIDATOR_ADDR=`${APP_SOLANA_KEYGEN} pubkey ${KEYS_PATH}`

SCRIPT_DIR=`cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P`

IS_DELINQUENT=`timeout ${TIMEOUT} ${APP_SOLANA} validators --output json | jq .delinquentValidators[].identityPubkey -r | grep ${VALIDATOR_ADDR}`

if [[ -z ${IS_DELINQUENT} ]]
then
    echo "`date` node is synced"
else
    echo "`date` ALARM! node is out of sync"
	 "${SCRIPT_DIR}/../Send_msg_toTelBot.sh" "${HOSTNAME} inform you:" "ALARM! Solana validator ${VALIDATOR_ADDR} is delinquent"  2>&1 > /dev/null
fi
