#/usr/bin 
SCP_DIR=$(cd $(dirname $0);pwd);
TGT_PATH=''

navi () {
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

index () {
    cd $TGT_PATH
    if [ -f ./index.html ]; then
        echo 'replace index file'
        rm ./index.html
    fi
    
    if [ -f $TGT_PATH/index.php ]; then
        echo -n ''
    else
        echo 'set index file'
        cp $SCP_DIR/../index.php $TGT_PATH/
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

navi
index
ttr

cp -r $SCP_DIR/../src/* $TGT_PATH/src
