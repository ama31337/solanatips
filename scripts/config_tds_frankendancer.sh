#!/bin/bash

LEDGER_PATH=""
SNAPSHOTS_PATH=""

cat > $HOME/config.toml <<EOF
user = "$USER"

[gossip]
    entrypoints = [
      "entrypoint.testnet.solana.com:8001",
      "entrypoint2.testnet.solana.com:8001",
      "entrypoint3.testnet.solana.com:8001",
    ]

[consensus]
    identity_path = "$HOME/keys/validator-keypair.json"
    vote_account_path = "$HOME/keys/vote-account-keypair.json"

    known_validators = [
        "5D1fNXzvv5NjV1ysLjirC4WY92RNsVH18vjmcszZd8on",
        "dDzy5SR3AXdYWVqbDEkVFdvSPCtS9ihF5kJkHCtXoFs",
        "Ft5fbkqNa76vnsjYNwjDZUXoTWpP7VYm3mtsaQckQADN",
        "eoKpUABi59aT4rR9HGS3LcMecfut9x7zJyodWWP43YQ",
        "9QxCLckBiJc783jnMvXZubK4wH86Eqqvashtrwvcsgkv",
    ]

[rpc]
    port = 8899
    full_api = true
    private = true

[reporting]
    solana_metrics_config = "host=https://metrics.solana.com:8086,db=tds,u=testnet_write,p=c4fa841aa918bf8274e3e2a44d77568d9861b3ea"

[log]
    path = "$HOME/logs/solana-validator.log"
    colorize = "auto"
    level_logfile = "INFO"
    level_stderr = "NOTICE"
    level_flush = "WARNING"

[ledger]
    path = "$LEDGER_PATH"
    #accounts_path = ""
[snapshots]
    incremental_snapshots = true
    full_snapshot_interval_slots = 25000
    incremental_snapshot_interval_slots = 100
    maximum_full_snapshots_to_retain = 1
    maximum_incremental_snapshots_to_retain = 1
    minimum_snapshot_download_speed = 100485760
    path = "$SNAPSHOTS_PATH"
    #incremental_path = ""

[layout]
    affinity = "auto"
    agave_affinity = "auto"
    net_tile_count = 1
    quic_tile_count = 1
    verify_tile_count = 2
    bank_tile_count = 2
    shred_tile_count = 2
EOF
