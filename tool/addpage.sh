#!/bin/bash
SCP_DIR=$(cd $(dirname $0);pwd);
cd $SCP_DIR/../
PAGE_NAME=''
OVERRIDE=''

# check env
if [ ! -d ./html ]; then
    error "could not found html directory"
fi

error () {
    echo "ERROR : $1"
    echo "ttr-web addpage is failed"
    exit -1
}

echo "### ttr-web add page ###"

# get page name
echo -n "page name : "
read PAGE_NAME
if [[ "" == ${PAGE_NAME} ]]; then
    error "page name is null"
fi

if [ -f "./html/${PAGE_NAME}.html" ]; then
    echo "${PAGE_NAME} is already exists."
    echo -n "override ${PAGE_NAME} page? "
    read OVERRIDE
    if [ "Y" == $OVERRIDE ] || [ "y" == $OVERRIDE ] || [ "yes" == $OVERRIDE ] || [ "YES" == $OVERRIDE ]; then
        OVERRIDE="Y"
    else
        error "user stop"
    fi
fi


# add html
sudo cp ./tool/tmpl/index.html ./tool/buff.html
if [ $? != 0 ]; then
    error "copy template was failed"
fi

grep -l '{@pagename}' ./tool/buff.html | xargs sed -i.bak -e "s/{@pagename}/$PAGE_NAME/g"
if [ $? != 0 ]; then
    error "replace string was failed"
fi

sudo cp ./tool/buff.html ./html/${PAGE_NAME}.html
if [ $? != 0 ]; then
    error "add html file was failed"
fi

sudo rm ./tool/buff.html ./tool/buff.html.bak



# add webpack config
sudo cp ./tool/tmpl/webpack.config.js ./tool/webpack.config.js.buff
if [ $? != 0 ]; then
    error "copy template was failed"
fi

grep -l '{@pagename}' ./tool/webpack.config.js.buff | xargs sed -i.bak -e "s/{@pagename}/$PAGE_NAME/g"
if [ $? != 0 ]; then
    error "replace string was failed"
fi

sudo cp ./tool/webpack.config.js.buff ./conf/webpack/webpack.config.${PAGE_NAME}.js
if [ $? != 0 ]; then
    error "add webpack file was failed"
fi

sudo rm ./tool/webpack.config.js.buff ./tool/webpack.config.js.buff.bak

# add build script
WEBPACK1='echo $($WEBPACK --config '
WEBPACK2="conf/webpack/webpack.config.${PAGE_NAME}.js"
WEBPACK3=');'
echo $WEBPACK1 $WEBPACK2 $WEBPACK3 >> ./tool/build.sh

# add urlmap
PAGEMAP="./conf/urlmap/pagemap.yaml"
if [ ! -f $PAGEMAP ]; then
    sudo touch $PAGEMAP
fi
echo "-" >> $PAGEMAP
if [ $? != 0 ]; then
    error "add urlmap was failed"
fi
echo "  url   : /${PAGE_NAME}" >> $PAGEMAP
echo "  conts : ./html/${PAGE_NAME}.html" >> $PAGEMAP


echo '### addpage is successful ###'
