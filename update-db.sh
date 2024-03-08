#!/bin/sh
# This is a script to migrate the SQL database with up-to date data or force the database back to certain version
#
# Usage ./update-db.sh

ls /migrations

version=$1
if [ -z "$version" ];
then
    ./migrate -path /migrations -database "mysql://${MYSQL_USERNAME}:${MYSQL_PASSWORD}@tcp(${MYSQL_HOSTNAME})/${MYSQL_DB_NAME}" -verbose up
else
    ./migrate -path /migrations -database "mysql://${MYSQL_USERNAME}:${MYSQL_PASSWORD}@tcp(${MYSQL_HOSTNAME})/${MYSQL_DB_NAME}" force ${version}
fi
