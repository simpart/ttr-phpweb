# ttr-web4php
this is routing pack for php.
it makes easy to build url-routing by creating a config file.

# support environment
- CentOS 7.x
- php7, pecl
- httpd

# quick start

## install php7
```
yum install -y epel-release
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
yum install -y --enablerepo=remi,remi-php70 php php-devel php-pear
```

```
pear channel-update pear.php.net
pecl install YAML
```


## install apache server
```
yum install -y httpd
```


