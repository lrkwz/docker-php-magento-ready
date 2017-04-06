#!/bin/bash
chown -R www-data. /var/www/magento/media/
touch /var/www/magento/var/log/system.log
touch /var/www/magento/var/log/exception.log
chown -R www-data. /var/www/magento/var/
cp /local.xml /var/www/magento/app/etc
php-fpm -F
