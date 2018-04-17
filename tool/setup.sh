#/bin/bash
SCP_DIR=$(cd $(dirname $0);pwd);
cd $SCP_DIR

bash ./setup/develop.sh
bash ./setup/php.sh
bash ./setup/http.sh

