#!/bin/bash

#create and switch to /var/www/ directory for BOTH nginx and wordpress
mkdir -p /var/www/
mkdir -p /var/www/html
cd /var/www/html
#removal of wordpress artifacts for fresh install
rm -rf *

if [ ! -f /var/www/html/wp-config.php ]; then
    #download and authorize php archive 
    #-O flag tells curl to save the file with the same name as it has on the server.
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 
    chmod +x wp-cli.phar 
    #rename to 'wp', move to system PATH dir, by now should be able to call wp anywhere
    mv wp-cli.phar /usr/local/bin/wp


    #actually download wordpress files
    wp core download --allow-root
    #work on real wp-config
    mv wp-config-sample.php wp-config.php
    #configure wp to talk to mariadb, swap out defaults for actual variables
    sed -i -r "s/database/$db_name/1"   wp-config.php
    sed -i -r "s/database_user/$db_user/1"  wp-config.php
    sed -i -r "s/passwod/$db_pwd/1"    wp-config.php
    sed -i -r "s/localhost/mariadb/1"    wp-config.php
    #NOTES
    #wp by default assumes database is on the same machine
    #as we all know all our services are on separate containers
    #in docker, containers find each other by their service name (in the compose file)
    #so 'mariadb' automatically resolves to MDB's container's IP.


    #installs WordPress and sets up config for admin acc, skip email to not send an email
    wp core install --url=$DOMAIN_NAME/ --title=$WP_TITLE --admin_user=$WP_ADMIN_USR --admin_password=$WP_ADMIN_PWD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root
    #creates secondary account
    wp user create $WP_USR $WP_EMAIL --role=author --user_pass=$WP_PWD --allow-root
    #admittedly i just copied this sample themes bit
    wp theme install astra --activate --allow-root

    PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
    #modify www.conf, change  every instant of php7.3-fpm.sock to 9000.
    sed -i "s/listen = \/run\/php\/php${PHP_VERSION}-fpm.sock/listen = 9000/g" /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
    #NOTES
    #allows PHP-FPM to listen like a TCP port instad of a unix domains socket
    #NGINX can reach it over the Docker network

    #this dir. used by PHP-FPM to store aforementioned domain sockets
    mkdir /run/php
fi

#-F tells PHP-FPM to run in (F)oreground and not as a daemon so it doesn't close.
/usr/sbin/php-fpm${PHP_VERSION} -F
