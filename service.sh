#!/bin/sh
echo "start php5-fpm ..."
exec /usr/sbin/php-fpm5.6 -F > /dev/stdout 2>&1
