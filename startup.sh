#!/bin/bash
touch ./var/log/system.log
touch ./var/log/exception.log
#chown -R www-data. ./var/ ./generated/ ./pub/media/
/etc/init.d/cron start
php-fpm -F
