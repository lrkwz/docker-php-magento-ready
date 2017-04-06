#!/bin/bash
chown -R www-data. ./media/
touch ./var/log/system.log
touch ./var/log/exception.log
chown -R www-data. ./var/
cp /local.xml ./app/etc
php-fpm -F
