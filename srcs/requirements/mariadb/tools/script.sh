#!/bin/bash

#change ip to 0.0.0.0 so it listens to the other containers
sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/g' \
    /etc/mysql/mariadb.conf.d/50-server.cnf

# starts MariaDB temporarily (to run SQL commands)
service mysql start
#NOTES
#despite saying mysql, we are actually running mariadb
#this way anything written for mysql would work identically with mariadb

echo "CREATE DATABASE IF NOT EXISTS $db1_name ;" > toberead.sql
echo "CREATE USER IF NOT EXISTS '$db1_user'@'%' IDENTIFIED BY '$db1_pwd' ;" >> toberead.sql
echo "GRANT ALL PRIVILEGES ON $db1_name.* TO '$db1_user'@'%' ;" >> toberead.sql
#set password
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '12345' ;" >> toberead.sql
#reload permission tables so changes take effect asap
echo "FLUSH PRIVILEGES;" >> toberead.sql
#feed toberead.sql into mysql
mysql < toberead.sql

# kills temp instance
kill $(cat /var/run/mysqld/mysqld.pid)
#NOTES
#it is the last running process that needs to stay in the foreground
#to keep the container alive; Docker monitors the LAST-launched process,
#if it dies, the container gets killed. daemons start and then go into the background
#to the terminal and Docker, it has finished executing and thus the container no longer serves a purpose.

# runs MariaDB directly in the foreground, no daemonizing
mysqld