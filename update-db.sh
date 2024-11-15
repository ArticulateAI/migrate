#!/bin/sh
# This is a script to migrate the SQL database with up-to date data or force the database back to certain version
#
# Usage ./update-db.sh

echo "Starting database migration..."
ls /migrations

action=$1
version=$2

echo "action: $action, version: $version"

if [ "$action" = "force" ]
then
    if [ -z "$version" ]
    then
        echo "force <version>: Please provide version number to force the database to"
        exit 1
    fi
    ./migrate -path /migrations -database "mysql://${MYSQL_USERNAME}:${MYSQL_PASSWORD}@tcp(${MYSQL_HOSTNAME})/${MYSQL_DB_NAME}" force ${version}
elif [ "$action" = "goto" ]
then
    if [ -z "$version" ]
    then
        echo "goto <version>: Please provide version number the database should go to"
        exit 1
    fi
    ./migrate -path /migrations -database "mysql://${MYSQL_USERNAME}:${MYSQL_PASSWORD}@tcp(${MYSQL_HOSTNAME})/${MYSQL_DB_NAME}" -verbose goto ${version}
else
    ./migrate -path /migrations -database "mysql://${MYSQL_USERNAME}:${MYSQL_PASSWORD}@tcp(${MYSQL_HOSTNAME})/${MYSQL_DB_NAME}" -verbose up
fi
