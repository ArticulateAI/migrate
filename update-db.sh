#!/bin/sh
# This is a script to migrate the SQL database with up-to date data or force the database back to certain version
#
# Usage ./update-db.sh

echo "Starting database migration..."
ls /migrations

args=$1

echo "args: $args"

if [ -z "$args" ]
then
    ./migrate -path /migrations -database "mysql://${MYSQL_USERNAME}:${MYSQL_PASSWORD}@tcp(${MYSQL_HOSTNAME})/${MYSQL_DB_NAME}" -verbose up
else
    ./migrate -path /migrations -database "mysql://${MYSQL_USERNAME}:${MYSQL_PASSWORD}@tcp(${MYSQL_HOSTNAME})/${MYSQL_DB_NAME}" $args
fi
