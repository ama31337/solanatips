#!/bin/bash

localversion=$(/home/$USER/.local/share/solana/install/active_release/bin/solana help | grep solana-cli | sed 's/solana-cli //' | sed 's/ (s.*)//')
gitversion=$(curl --silent "https://api.github.com/repos/solana-labs/solana/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")' | sed 's/v//')
diff <(echo "$localversion") <(echo "$gitversion")

if [ $? -ne 0 ]; then
	echo "need to update, localversion is $localversion, new release is $gitversion"
	echo -n "want to update (y/n)? "
	read answer
	if [ "$answer" != "${answer#[Yy]}" ] ;then
		echo "start update"
		curl -sSf https://raw.githubusercontent.com/solana-labs/solana/v${gitversion}/install/solana-install-init.sh | sh -s - v${gitversion}
		solana-install update
		sudo systemctl stop solana-tds
		sudo systemctl start solana-tds
		echo "update complete"
		localversion=$(/home/$USER/.local/share/solana/install/active_release/bin/solana help | grep solana-cli | sed 's/solana-cli //' | sed 's/ (s.*)//')
		echo "current node version:"
		echo "$localversion"
	else
		echo "exit"
	fi
else
	echo "localversion is $localversion, latest release is $gitversion"
	echo "node is up to date"


fi
