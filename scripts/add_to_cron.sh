#!/bin/bash

SCRIPT_DIR=`cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P`
mkdir -p $HOME/logs

crontab -l | 
    { cat; 
        echo "" ;
        echo "#solana cronjobs on $HOSTNAME" ;
        echo "*/5 * * * *      cd $SCRIPT_DIR && ./check_sync.sh >> $HOME/logs/check_sync.log "; 
        echo "*/5 * * * *      cd $SCRIPT_DIR && ./is_delinquent.sh >> $HOME/logs/is_delinquent.log ";
        echo "0 */4 * * *      cd $SCRIPT_DIR && ./check_skip.sh >> $HOME/logs/check_skip.log ";
    } | crontab -

