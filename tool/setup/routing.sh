#!/bin/bash 
SCP_DIR=$(cd $(dirname $0);pwd);
TGT_PATH=$1
APP_TITLE=$2

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

add_backend () {
    echo "*** copy routing src"
    cp -r $SCP_DIR/../../src/ $TGT_PATH/$APP_TITLE
    
    cd $TGT_PATH/$APP_TITLE/src/php
    if [ $? != 0 ]; then
        error "could not change dir : $TGT_PATH/$APP_TITLE/src/php"
    fi
    
    echo "*** configure routing"
    sed -i -e "s/@{APP_TITLE}/$APP_TITLE/g" $TGT_PATH/$APP_TITLE/src/php/com/define.php
    if [ $? != 0 ]; then
        error "could not edit file $TGT_PATH/src/php/rtg/define.php"
    fi

    if [ ! -f "./ttr/require.php" ]; then
        echo -e "*** install tetraring4php"
        git clone https://github.com/simpart/tetraring4php.git ttr
        if [ $? != 0 ]; then
            error "could not clone github.com/simpart/tetraring4php.git"
        fi
    fi
       
    echo "*** copy url mapping config template"
    sudo cp -r $SCP_DIR/../../conf/urlmap/ $TGT_PATH/$APP_TITLE/conf/
    if [ $? != 0 ]; then
        error "could not copy $SCP_DIR/../../conf/urlmap/ -> $TGT_PATH/$APP_TITLE/conf/"
    fi
    
}

deploy_index () {
    echo "*** deploy index"
    sudo cp $SCP_DIR/../tmpl/index.html $TGT_PATH/$APP_TITLE/html/
    if [ $? != 0 ]; then
        error "copy template was failed"
    fi
    
    grep -l '<title>{@pagename}</title>' $TGT_PATH/$APP_TITLE/html/index.html | xargs sed -i.bak -e "s/<title>{@pagename}<\/title>/<title>${APP_TITLE}<\/title>/g"
    if [ $? != 0 ]; then
        error "replace string was failed"
    fi
    
    grep -l "<script src='./src/js/app/{@pagename}.js' defer></script>" $TGT_PATH/$APP_TITLE/html/index.html | xargs sed -i.bak -e "s/<script src='.\/src\/js\/app\/{@pagename}.js' defer><\/script>/<script src='.\/src\/js\/app\/index.js' defer><\/script>/g"
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

add_tools () {
    sudo cp $SCP_DIR/../addpage.sh $TGT_PATH/$APP_TITLE/tool/
    if [ $? != 0 ]; then
        error "copy addpage script was faild"
    fi
    sudo cp -r $SCP_DIR/../tmpl $TGT_PATH/$APP_TITLE/tool/
    if [ $? != 0 ]; then
        error "copy template was faild"
    fi
}

error () {
    echo "ERROR : $1"
    echo "setup routing is failed"
    exit -1
}


echo "*** start setup routing"
get_inf
add_backend
deploy_index
add_tools

echo "*** successful setup routing"
