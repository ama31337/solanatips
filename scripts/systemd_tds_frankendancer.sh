#!/bin/bash

# Exit on error
set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)

# Execute the configuration script
if [ -f "$SCRIPT_DIR/config_tds_frankendancer.sh" ]; then
    echo "Executing config_tds_frankendancer.sh..."
    bash "$SCRIPT_DIR/config_tds_frankendancer.sh"
else
    echo "Error: config_tds_frankendancer.sh file not found in $SCRIPT_DIR. Exiting."
    exit 1
fi

# Create the systemd service file
SERVICE_FILE="/etc/systemd/system/solana-tds.service"
echo "Creating systemd service file at $SERVICE_FILE..."

sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=Solana TDS Frankendancer Validator
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=1
User=$USER
LimitNOFILE=2048000

Environment="SOLANA_METRICS_CONFIG=host=https://metrics.solana.com:8086,db=tds,u=testnet_write,p=c4fa841aa918bf8274e3e2a44d77568d9861b3ea"

ExecStart=sudo $(which fdctl) run --config $HOME/config.toml

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable, and start the service
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "Service setup completed successfully!"
