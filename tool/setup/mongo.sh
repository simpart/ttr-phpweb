#/bin/bash
SCP_DIR=$(cd $(dirname $0);pwd);

error () {
    echo "ERROR : $1"
    echo "setup mongo is failed"
    exit -1
}

cat $SCP_DIR/../../tmpl/mongodb.repo >  /etc/yum.repos.d/mongodb.repo
yum install -y mongodb-org
systemctl enable mongod
systemctl start mongod
    
yum --enablerepo=epel,remi,remi-php70 install php70-php-pecl-mongodb
    
EXT_TXT="extension="$(find / -name "mongodb.so")
INI_PATH="/etc/php.ini"
if [ ! -f $INI_PATH ]; then
    error "could not found php.ini"
fi

CHK_EXT=$(cat $INI_PATH | grep $EXT_TXT)
if [[ "" == ${CHK_EXT} ]]; then
    echo -e "\n*** add extension to php.ini ***\n"
    echo $EXT_TXT >> $INI_PATH
fi
