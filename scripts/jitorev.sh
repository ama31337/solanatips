#!/bin/bash

# input vars
VOTE_KEY_NAME="vote-account-keypair.json"

# calc vars
SCRIPT_DIR=`cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P`
APP_SOLANA="${HOME}/.local/share/solana/install/active_release/bin/solana"
APP_SOLANA_KEYGEN="${HOME}/.local/share/solana/install/active_release/bin/solana-keygen"
VOTE_KEYS_PATH=$(find $HOME -iname ${VOTE_KEY_NAME} | head -n 1)
VOTE_PUBKEY=$(${APP_SOLANA_KEYGEN} pubkey ${VOTE_KEYS_PATH} )

curl "https://jito.retool.com/api/public/e9932354-a5bb-44ef-bce3-6fbb7b187a89/query?queryName=filtered_validators" \
  -H "content-type: application/json" \
  --data-raw '{
    "userParams": {
      "fieldParams": {"length": 0},
      "queryParams": {"0": "'"$VOTE_PUBKEY"'", "length": 1},
      "updateParams": {"length": 0},
      "insertParams": {"length": 0},
      "projectionParams": {"length": 0},
      "optionsParams": {"length": 0},
      "sortByParams": {"length": 0},
      "skipParams": {"length": 0},
      "limitParams": {"length": 0},
      "aggregationParams": {"length": 0},
      "collectionParams": {"length": 0},
      "databaseParams": {},
      "operationsParams": {},
      "hintParams": {}
    },
    "password": "",
    "environment": "production",
    "queryType": "NoSqlQuery",
    "frontendVersion": "1",
    "releaseVersion": null,
    "includeQueryExecutionMetadata": true,
    "streamResponse": false
  }' | jq .queryData | jq -r '.[] | "\(.epoch): \(.mev_revenue/1000000000)"'
