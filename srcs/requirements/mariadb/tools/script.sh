#!/bin/bash

#change ip to 0.0.0.0 so it listens to the other containers
sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/g' \
    /etc/mysql/mariadb.conf.d/50-server.cnf

# create socket directory and give mysql user ownership
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# starts MariaDB temporarily (to run SQL commands)
#service mysql start
#NOTES
#despite saying mysql, we are actually running mariadb
#this way anything written for mysql would work identically with mariadb
#service don't work the same way in containers, so this is not correct

if [ ! -d /var/lib/mysql/$db_name ]; then
    #start mariadb without service system
    mysqld_safe --skip-networking &
    sleep 3


    echo "CREATE DATABASE IF NOT EXISTS $db_name ;" > toberead.sql
    echo "CREATE USER IF NOT EXISTS '$db_user'@'%' IDENTIFIED BY '$db_pwd' ;" >> toberead.sql
    echo "GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'%' ;" >> toberead.sql
    #set password
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$db1_root_pwd' ;" >> toberead.sql
    #reload permission tables so changes take effect asap
    echo "FLUSH PRIVILEGES;" >> toberead.sql
    #feed toberead.sql into mysql
    mysql < toberead.sql

    # kills temp instance
    kill $(cat /var/run/mysqld/mysqld.pid)
    sleep 1
fi
#NOTES
#it is the last running process that needs to stay in the foreground
#to keep the container alive; Docker monitors the LAST-launched process,
#if it dies, the container gets killed. daemons start and then go into the background
#to the terminal and Docker, it has finished executing and thus the container no longer serves a purpose.

# runs MariaDB directly in the foreground, no daemonizing, AS THE USER NOT ROOT
mysqld --user=mysql
#NOTES
#mariadb refuses to run as root typically, docker runs everything as root