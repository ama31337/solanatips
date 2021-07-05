#!/bin/bash

# input vars
KEY_NAME="validator-keypair.json"
SKIP_LIMIT=1

# calc vars
SCRIPT_DIR=`cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P`
APP_SOLANA=`which solana`
APP_SOLANA_KEYGEN=`which solana-keygen`
KEYS_PATH=$(find $HOME -iname ${KEY_NAME} | head -n 1)
ID_PUBKEY=`${APP_SOLANA_KEYGEN} pubkey ${KEYS_PATH}`

# check skiprate
SKIP=`${APP_SOLANA} block-production | grep -e ${ID_PUBKEY}`
#SKIP=`${APP_SOLANA} block-production --url http://127.0.0.1:8899 | grep -e ${ID_PUBKEY}`
SKIP_PECENT=`echo ${SKIP} | gawk '{print $NF}'`
SKIP_PECENT=${SKIP_PECENT%"%"}

SKIP_TOTAL=`${APP_SOLANA} block-production | grep -e total`
#SKIP_TOTAL=`${APP_SOLANA} block-production --url http://127.0.0.1:8899 | grep -e total`
SKIP_PECENT_TOTAL=`echo ${SKIP_TOTAL} | gawk '{print $NF}'`
SKIP_PECENT_TOTAL=${SKIP_PECENT_TOTAL%"%"}

#echo "$SKIP"
echo "my skip ${SKIP_PECENT}"
echo "avg skip ${SKIP_PECENT_TOTAL}"


if (( $(echo "${SKIP_PECENT} > ${SKIP_PECENT_TOTAL}" | bc -l) ))
then
	echo "`date` ALARM! skiprate is above average"
	 "${SCRIPT_DIR}/../Send_msg_toTelBot.sh" "$HOSTNAME inform you:" "!!! skiprate ${SKIP_PECENT}% is above average ${SKIP_PECENT_TOTAL}% !!!"  2>&1 > /dev/null
else 
	echo "`date` skiprate is below average"
    	"${SCRIPT_DIR}/../Send_msg_toTelBot.sh" "$HOSTNAME" "skiprate ${SKIP_PECENT}% is below average ${SKIP_PECENT_TOTAL}%"  2>&1 > /dev/null
fi
