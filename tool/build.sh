#/usr/bin 
SCP_DIR=$(cd $(dirname $0);pwd);
TGT_PATH=''

check_path () {
    echo '*** ttr-web init script ***'
    cd $SCP_DIR/../
    echo -n 'target path : '
    read TGT_PATH

    if [ -d $TGT_PATH ]; then
        echo ''
    else
        echo 'target path is not found'
        exit -1
    fi
     
}

init_php () {
    yum install -y gcc libyaml libyaml-devel
    if [ $? != 0 ]; then
        exit;
    fi
    pear channel-update pear.php.net
    pecl install YAML
    
    EXT_TXT="extension=yaml.so"
    INI_PATH="/etc/php.ini"
    CHK_YML=$(cat $INI_PATH | grep $EXT_TXT)
    
    if [[ "" == ${CHK_YML} ]]; then
        echo "add extension"
        echo $EXT_TXT >> $INI_PATH
    fi
}

init_serv () {
    yum install -y httpd
    if [ $? != 0 ]; then
        exit;
    fi
    
    cp $SCP_DIR/route.conf.tmpl $SCP_DIR/route.conf
    if [ $? != 0 ]; then
        exit;
    fi
    
    sed -e "1i<Directory \"$TGT_PATH\">\n" -i $SCP_DIR/route.conf
    if [ $? != 0 ]; then
        exit;
    fi

    cp $SCP_DIR/route.conf /etc/httpd/conf.d/
    if [ $? != 0 ]; then
        exit;
    fi
    
    rm $SCP_DIR/route.conf
    if [ $? != 0 ]; then
        exit;
    fi
    
    systemctl stop httpd
    if [ $? != 0 ]; then
        exit;
    fi
    systemctl start httpd
    if [ $? != 0 ]; then
        exit;
    fi
}

ttr () {
    cd $SCP_DIR/../src/php
    
    if [ -d ./ttr ]; then
        echo -n ''
    else
        git clone https://github.com/simpart/tetraring4php.git ttr
    fi
}

check_path
init_php
init_serv

#index

#ttr

#cp -r $SCP_DIR/../src/* $TGT_PATH/src
