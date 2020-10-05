#!/bin/bash

# this script will check local node veersion and compare it to latest release in github.
# if they are differ, inform you in telegram.
# to use this script in cron use absolute path and change $USER to your actual user name.

SCRIPT_DIR=`cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P`

#localversion=$(solana help | grep solana-cli | sed 's/solana-cli //')
localversion=$($HOME/.local/share/solana/install/active_release/bin/solana help | grep solana-cli | sed 's/solana-cli //')
gitversion=$(curl --silent "https://api.github.com/repos/solana-labs/solana/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")' | sed 's/v//')
diff <(echo "$localversion") <(echo "$gitversion")

if [ $? -ne 0 ];
        then
                echo "need to update"
                "${SCRIPT_DIR}/sendmsg_tgbot.sh" "$HOSTNAME inform you:" "new version $gitversion of Solana node released, need to update"  2>&1 > /dev/null
                echo $HOSTNAME ' inform you: new version ' $gitversion ' of Solana node released, need to update'
        else
                echo $HOSTNAME ' inform you: active node up to update'
fi
