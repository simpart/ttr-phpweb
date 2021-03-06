#/bin/bash
SCP_DIR=$(cd $(dirname $0);pwd);
cd $SCP_DIR

TGT_PATH=$1
APP_TITLE=$2

error () {
    echo "ERROR : $1"
    echo "setup is failed"
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

add_tools () {
    sudo cp -r $SCP_DIR/init $TGT_PATH/$APP_TITLE/tool/
    if [ $? != 0 ]; then
        error "copy addpage script was faild"
    fi
}

get_inf
add_tools

bash ./setup/routing.sh $TGT_PATH $APP_TITLE
if [ $? != 0 ]; then
    exit -1
fi

bash ./setup/php.sh
if [ $? != 0 ]; then
    exit -1
fi

bash ./setup/httpd.sh $TGT_PATH $APP_TITLE
if [ $? != 0 ]; then
    exit -1
fi

bash ./setup/mongo.sh
if [ $? != 0 ]; then
    exit -1
fi

