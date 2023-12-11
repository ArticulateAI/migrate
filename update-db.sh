#!/bin/sh
# This is a script to migrate the SQL database with up-to date data or force the database back to certain version
#
# Usage ./update-db.sh

mkdir -p sql_data

DEFAULT_ENV_TYPE="staging"
FOLDER_NAME=${ENV_TYPE:-$DEFAULT_ENV_TYPE}
if [ -z "${ENV_TYPE}" ]; then
    echo "ENV_TYPE variable is unset or set to the empty string. Using staging as default..."
fi

# check if folder name is staging or prod
if [ "$FOLDER_NAME" = "staging" ]; then
    echo "using staging migrations"
elif [ "$FOLDER_NAME" = "prod" ]; then
    echo "using prod migrations"
else
    echo "ENV_TYPE is set to '$FOLDER_NAME'. Please set ENV_TYPE to staging or prod"
    exit 1
fi

aws s3 cp "s3://docker-container-data/migrations/${FOLDER_NAME} ./sql_data/" --recursive

version=$1
if [ -z "$version" ];
then
    ./migrate -path /sql_data -database "mysql://${MYSQL_USERNAME}:${MYSQL_PASSWORD}@tcp(${MYSQL_HOSTNAME})/${MYSQL_DB_NAME}" -verbose up
else
    ./migrate -path /sql_data -database "mysql://${MYSQL_USERNAME}:${MYSQL_PASSWORD}@tcp(${MYSQL_HOSTNAME})/${MYSQL_DB_NAME}" force ${version}
fi