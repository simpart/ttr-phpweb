#/bin/bash
SCP_DIR=$(cd $(dirname $0);pwd);
TGT_PATH=$1
APP_TITLE=$2

error () {
    echo "ERROR : $1"
    echo "ttr-web build is failed"
    exit -1
}


get_inf () {
    # get deploy target path
    if [[ $TGT_PATH == "" ]]; then
        echo -n "deploy path : "
        read TGT_PATH
    fi
    if [ ! -d $TGT_PATH ]; then
        error "could not found target path"
    fi

    # get application title
    if [[ $APP_TITLE == "" ]]; then
        echo -n "app title : "
        read APP_TITLE
    fi
    if [[ $APP_TITLE == "" ]]; then
        error "app title is null"
    fi

    if [ ! -d $TGT_PATH/$APP_TITLE ]; then
        echo "*** create app directory"
        sudo mkdir $TGT_PATH/$APP_TITLE
        if [ $? != 0 ]; then
            error "could not create $TGT_PATH/$APP_TITLE directory"
        fi
    fi
}

echo "*** start setup httpd"
get_inf

echo "*** install httpd"
yum install -y httpd
if [ $? != 0 ]; then
    error "install httpd is failed"
fi

echo "*** set route.conf"
cp $SCP_DIR/../../conf/serv/httpd.conf /etc/httpd/conf.d/${APP_TITLE}.conf
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

echo "*** successful setup httpd"
