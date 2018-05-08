#!/bin/bash
SCP_DIR=$(cd $(dirname $0);pwd);
#cd $SCP_DIR/../../

error () {
    echo "ERROR : $1"
    echo "the script is failed"
    exit -1
}

sudo php $SCP_DIR/../../src/php/init/database.php $SCP_DIR/../../conf/database/database.yml
