#!/bin/bash

KEY_NAME="validator-keypair.json"
TIMEOUT=30

SCRIPT_DIR=`cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P`
APP_SOLANA=`which solana`
KEYS_PATH=$(find $HOME -iname ${KEY_NAME} | head -n 1)

INSYNC=`timeout ${TIMEOUT} ${APP_SOLANA} catchup ${KEYS_PATH} http://127.0.0.1:8899 | grep caught`

if [[ -z ${INSYNC} ]]
then
	echo "`date` ALARM! node is out of sync"
	 "${SCRIPT_DIR}/../Send_msg_toTelBot.sh" "$HOSTNAME inform you:" "ALARM! Solana MB node is out of sync"  2>&1 > /dev/null
else 
	echo "`date` node is synced"
fi
