#/bin/bash
SCP_DIR=$(cd $(dirname $0);pwd);
cd $SCP_DIR

bash ./setup/develop.sh
if [ $? != 0 ]; then
    exit -1
fi

bash ./setup/php.sh
if [ $? != 0 ]; then
    exit -1
fi

bash ./setup/httpd.sh
if [ $? != 0 ]; then
    exit -1
fi

