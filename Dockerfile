FROM php:7.1-fpm

MAINTAINER Luca Orlandi <luca.orlandi@gmail.com>

# install the PHP extensions we need
RUN apt-get update && apt-get upgrade -y && apt-get install -y libpng-dev libjpeg-dev libmcrypt-dev libcurl4-openssl-dev libicu-dev \
 && rm -rf /var/lib/apt/lists/* \
 && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
 && docker-php-ext-install gd opcache intl pdo_mysql mcrypt

RUN yes | pecl install xdebug \
     && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
     && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
     && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini \
     && echo "xdebug.remote_connect_back=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
     && echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/xdebug.ini \
     && echo "xdebug.remote_host=127.17.0.1" >> /usr/local/etc/php/conf.d/xdebug.ini \
     && cp /usr/local/etc/php/conf.d/xdebug.ini /usr/local/etc/php-fpm.d/

RUN apt-get update && apt-get install -y msmtp
ADD msmtprc /etc/.msmtp_php
RUN chown www-data. /etc/.msmtp_php && chmod 600 /etc/.msmtp_php

# magento2 requirements
RUN apt-get install -y libxslt1.1 libxslt1-dev
RUN docker-php-ext-install xsl soap zip

#ADD magento.ini /usr/local/etc/php-fpm.d/magento.conf
ADD magento.ini /usr/local/etc/php/conf.d/
ADD magento.pool.conf /usr/local/etc/php-fpm.d/www.conf
#ADD 20-xdebug.ini  /usr/local/etc/php-fpm.d/20-xdebug.conf
#ADD 20-xdebug.ini  /usr/local/etc/php/conf.d/

RUN usermod -u 1000 www-data

RUN apt-get install -y cron
RUN apt-get autoremove -y && apt-get autoclean -y
ADD crontab /etc/cron.d/magento
RUN chmod 0644 /etc/cron.d/magento

VOLUME /var/www/magento
RUN mkdir /var/www/magento/var /var/www/magento/media && chown -Rf www-data. /var/www/magento/var /var/www/magento/media

COPY local.xml /
COPY startup.sh /

CMD ["/startup.sh"]

EXPOSE 9000
