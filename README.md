# ttr-web4php
this is url routing pack for php.
it makes easy to build url-routing by a config file.

# support environment
- CentOS 7.x
- php7, pecl, yaml-mod
- httpd

# build
## quick build

```
./tool/build.sh
```


## manual build
### install php7
```
yum install -y epel-release
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
yum install -y --enablerepo=remi,remi-php70 php php-devel php-pear
```

### install yaml-module
```
pear channel-update pear.php.net
pecl install YAML
# add 'extension=yaml.so' to php.ini
```

### install apache server
```
yum install -y httpd
```

### set httpd config
```
cp ./conf/serv/httpd.conf /etc/httpd/conf.d/routing.conf
vi /etc/httpd/conf.d/routing.conf   # edit deploy path
systemctrl restart httpd
```

### install util library
```
cd ./src/php
git clone https://github.com/simpart/tetraring4php.git ttr
```
### copy mapping config
```
cd /path/to/ttr-web4php
cp -r ./conf/urlmap /path/to/deploy/target/conf
```




