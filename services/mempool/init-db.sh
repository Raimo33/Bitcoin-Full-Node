#!/bin/ash

/usr/bin/mysqld --datadir=/var/lib/mysql --user=mariadb_user &

while ! mysqladmin ping --silent; do
	sleep 1
done

mysql mysql -e "create database mempool"
mysql -e "grant all privileges on mempool.* to 'mempool'@'localhost' identified by 'mempool'"

mysql mempool < mempool-schema.sql

mysqladmin -u root -h localhost shutdown