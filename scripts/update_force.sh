#!/bin/bash

localversion=$(/home/$USER/.local/share/solana/install/active_release/bin/solana help | grep solana-cli | sed 's/solana-cli //' | sed 's/ (s.*)//')
gitversion=$(curl --silent "https://api.github.com/repos/solana-labs/solana/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")' | sed 's/v//')

echo "localversion is $localversions, new release is $gitversion"
echo "Which version you want to install?"
read ver
echo "start"

curl -sSf https://raw.githubusercontent.com/solana-labs/solana/v${ver}/install/solana-install-init.sh | sh -s - v${ver}
solana-install update
sudo systemctl stop solana-tds
sudo systemctl start solana-tds

localversion=$(/home/$USER/.local/share/solana/install/active_release/bin/solana help | grep solana-cli | sed 's/solana-cli //' | sed 's/ (s.*)//')

echo "update done"
echo "current node version:"
echo "$localversion"
echo "latest release:"
echo "$gitversion"

