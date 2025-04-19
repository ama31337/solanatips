#!/bin/bash

SCRIPT_DIR=`cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P`
BIN_PATH="$HOME/.local/share/solana/install/active_release/bin"

# Source the env.sh file on the local machine
source env.sh

# Set the local_test variable based on the value of TEST in env.sh
LOCAL_LEDGER=${LEDGER_PATH}

# Use ssh to source the env.sh file on the remote machine and set the remote_test variable
REMOTE_LEDGER=$(ssh sol@${1} -p 58228 "source env.sh; echo \${LEDGER_PATH}")

# Perform some actions using the local_test and remote_test variables
echo "Local ledger path: ${LOCAL_LEDGER}"
echo "Remote ledger path: ${REMOTE_LEDGER}"

DESTINATION="sol@${1}:${REMOTE_LEDGER}"

# check connection
server=sol@${1}      # server IP
port=58228                 # port
connect_timeout=5       # Connection timeout
ssh -q -o BatchMode=yes  -o StrictHostKeyChecking=no -o ConnectTimeout=$connect_timeout $server -p $port 'exit 0'
if [ $? == 0 ];then
    echo "start script"
    ${BIN_PATH}/agave-validator -l ${LOCAL_LEDGER} wait-for-restart-window --min-idle-time 2 --skip-new-snapshot-check
    ${BIN_PATH}/agave-validator -l ${LOCAL_LEDGER} set-identity ${HOME}/keys/unstaked-identity.json
    ln -sf ${HOME}/keys/unstaked-identity.json ${HOME}/keys/identity.json
    rsync -avz -e "ssh -p $port" ${LOCAL_LEDGER}/tower-1_9-$(${BIN_PATH}/solana-keygen pubkey ${HOME}/keys/validator-keypair.json).bin ${DESTINATION}
    sleep 1
    ssh sol@${1} -p $port 'bash -s' < ${SCRIPT_DIR}/become_active.sh
else
    echo "SSH connection to $server over port $port is not possible, stop"
fi

echo "done"
