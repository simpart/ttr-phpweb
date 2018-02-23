#!/bin/bash 
SCP_DIR=$(cd $(dirname $0);pwd);
TGT_PATH=''
APP_TITLE=''

get_inf () {
    echo "start ttr-web build"
    cd $SCP_DIR/../
    echo -n "deploy path : "
    read TGT_PATH
    
    if [ ! -d $TGT_PATH ]; then
        error "could not found target path"
    fi
    
    echo -n "app title : "
    read APP_TITLE
    if [[ "" == ${APP_TITLE} ]]; then
        error "app title is null"
    fi
    
    if [ ! -d $TGT_PATH ]; then
        echo "*** create app directory"
        mkdir $TGT_PATH/$APP_TITLE
        if [ $? != 0 ]; then
            error "could not create $TGT_PATH/$APP_TITLE directory"
        fi
    fi
}

init_php () {
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
}

init_serv () {
    echo "*** install httpd"
    yum install -y httpd
    if [ $? != 0 ]; then
        error "install httpd is failed"
    fi
    
    echo "*** set route.conf"
    cp $SCP_DIR/../conf/serv/httpd.conf /etc/httpd/conf.d/${APP_TITLE}.conf
    if [ $? != 0 ]; then
        error "set route.conf is failed"
    fi
    
    echo "*** edit route.conf"
    sed -i -e '1,1d' /etc/httpd/conf.d/${APP_TITLE}.conf
    sed -i -e "1i <Directory \"$TGT_PATH/$APP_TITLE\">" /etc/httpd/conf.d/${APP_TITLE}.conf
    if [ $? != 0 ]; then
        error "edit route.conf is failed"
    fi
    
    echo "*** restart httpd"
    systemctl stop httpd
    systemctl start httpd
}

add_pack () {
    echo "*** copy routing src"
    cp -r $SCP_DIR/../src/ $TGT_PATH/$APP_TITLE
    
    cd $TGT_PATH/$APP_TITLE/src/php
    if [ $? != 0 ]; then
        error "could not change dir : $TGT_PATH/$APP_TITLE/src/php"
    fi
    
    echo "*** configure routing"
    sed -i -e "s/@APP_TITLE/$APP_TITLE/g" $TGT_PATH/$APP_TITLE/src/php/com/define.php
    if [ $? != 0 ]; then
        error "could not edit file $TGT_PATH/src/php/rtg/define.php"
    fi

    if [ ! -d "./ttr" ]; then
        echo -e "*** install tetraring4php"
        git clone https://github.com/simpart/tetraring4php.git ttr
        if [ $? != 0 ]; then
            error "could not clone github.com/simpart/tetraring4php.git"
        fi
    fi
       
    echo "*** copy url mapping config template"
    sudo cp -r $SCP_DIR/../conf/urlmap/ $TGT_PATH/$APP_TITLE/conf/
    if [ $? != 0 ]; then
        error "could not copy $SCP_DIR/../conf/urlmap/ -> $TGT_PATH/$APP_TITLE/conf/"
    fi
    
}

deploy_index () {
    echo "*** deploy index"
    sudo cp $TGT_PATH/$APP_TITLE/index.html $TGT_PATH/$APP_TITLE/html/
    if [ $? != 0 ]; then
        error "copy template was failed"
    fi
    
    grep -l '<title></title>' $TGT_PATH/$APP_TITLE/html/index.html | xargs sed -i.bak -e "s/<title><\/title>/<title>${APP_TITLE}<\/title>/g"
    if [ $? != 0 ]; then
        error "replace string was failed"
    fi
    
    sudo rm $TGT_PATH/$APP_TITLE/html/index.html.bak
    
    PAGEMAP="$TGT_PATH/$APP_TITLE/conf/urlmap/pagemap.yaml"
    if [ ! -f $PAGEMAP ]; then
        sudo touch $PAGEMAP
        echo "-" >> $PAGEMAP
        if [ $? != 0 ]; then
            error "add urlmap was failed"
        fi
        echo "  url   : /" >> $PAGEMAP
        echo "  conts : ./html/index.html" >> $PAGEMAP
        
    fi
}

add_scp () {
    sudo cp $SCP_DIR/addpage.sh $TGT_PATH/$APP_TITLE/tool/
    if [ $? != 0 ]; then
        error "copy addpage script was faild"
    fi
    sudo cp -r $SCP_DIR/tmpl $TGT_PATH/$APP_TITLE/tool/
    if [ $? != 0 ]; then
        error "copy template was faild"
    fi
}

error () {
    echo "ERROR : $1"
    echo "ttr-web build is failed"
    exit -1
}

get_inf
init_php
init_serv
add_pack
deploy_index
add_scp

echo "ttr-web build is succeed"
