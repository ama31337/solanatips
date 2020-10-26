#!/bin/bash

localversion=$(/home/$USER/.local/share/solana/install/active_release/bin/solana help | grep solana-cli | sed 's/solana-cli //' | sed 's/ (s.*)//')
gitversion=$(curl --silent "https://api.github.com/repos/solana-labs/solana/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")' | sed 's/v//')
diff <(echo "$localversion") <(echo "$gitversion")

if [ $? -ne 0 ];
        then
                echo "need to update, localversion is $localversion, new release is $gitversion"
		echo "Which version you want to install?"
		read ver
		echo "start"

		curl -sSf https://raw.githubusercontent.com/solana-labs/solana/v${ver}/install/solana-install-init.sh | sh -s - v${ver}
		solana-install update
		sudo systemctl stop solana-tds
		sudo systemctl start solana-tds
		echo "update complete"
		localversion=$(/home/$USER/.local/share/solana/install/active_release/bin/solana help | grep solana-cli | sed 's/solana-cli //' | sed 's/ (s.*)//')
		echo "current node version:"
		echo "$localversion"
	else
		echo "localversion is $localversion, latest release is $gitversion"
		echo "node is up to date"

fi

