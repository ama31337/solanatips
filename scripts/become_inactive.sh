#!/bin/bash

SCRIPT_DIR=`cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P`
BIN_PATH="$HOME/.local/share/solana/install/active_release/bin"
DESTINATION="sol@${1}:/home/sol/validator-ledger/"

# check connection
server=sol@${1}      # server IP
port=555                 # ssh port
connect_timeout=5       # Connection timeout
ssh -q -o BatchMode=yes  -o StrictHostKeyChecking=no -o ConnectTimeout=$connect_timeout $server -p $port 'exit 0'
if [ $? == 0 ];then
   echo "start script"
   ${BIN_PATH}/solana-validator -l ${HOME}/validator-ledger wait-for-restart-window --min-idle-time 2 --skip-new-snapshot-check
   ${BIN_PATH}/solana-validator -l ${HOME}/validator-ledger set-identity ${HOME}/keys/unstaked-identity.json
   ln -sf ${HOME}/keys/unstaked-identity.json ${HOME}/keys/identity.json
   scp -r -P $port ${HOME}/validator-ledger/tower-1_9-$(${BIN_PATH}/solana-keygen pubkey ${HOME}/keys/validator-keypair.json).bin ${DESTINATION}
   ssh sol@${1} -p $port 'bash -s' < ${SCRIPT_DIR}/become_active.sh
else
   echo "SSH connection to $server over port $port is not possible, stop"
fi

echo "done"
