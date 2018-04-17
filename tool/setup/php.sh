#/bin/bash

error () {
    echo "ERROR : $1"
    echo "setup php is failed"
    exit -1
}


echo "*** start setup php"

echo "*** install epel-release"
yum install -y epel-release

echo "*** install remi-release"
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

echo "*** install php7"
yum install -y --enablerepo=remi,remi-php70 php php-devel php-pear

echo "*** install yaml-module"
# install yaml module
yum install -y gcc libyaml libyaml-devel
pear channel-update pear.php.net
pecl install YAML

EXT_TXT="extension=yaml.so"
INI_PATH="/etc/php.ini"
if [ ! -f $INI_PATH ]; then
    error "could not found php.ini"
fi

CHK_YML=$(cat $INI_PATH | grep $EXT_TXT)
if [[ "" == ${CHK_YML} ]]; then
    echo -e "\n*** add extension to php.ini ***\n"
    echo $EXT_TXT >> $INI_PATH
fi

echo "*** successful setup php"
