#!/bin/bash

: ${REDIS_HOST:=localhost}
: ${REDIS_PORT:=6379}

# Wait for redis to be up
while ! nc -z $REDIS_HOST $REDIS_PORT ; do sleep 3; done

CONFIG_FILE=/usr/src/CartoDB-SQL-API-$SQL_VERSION/config/environments/$ENVIRONMENT.js

# Default to listening on all interfaces so container links will work
perl -0pi -e 's/(module.exports.node_host\s*=\s*[\x27\x60])[.\d\w]*/${1}'"${NODE_HOST:-0.0.0.0}"'/igs' $CONFIG_FILE

perl -0pi -e 's/(module.exports.environment\s*=\s*[\x27\x60])[.\d\w]*/${1}'"$ENVIRONMENT"'/igs' $CONFIG_FILE
if [ ! -z "$ENVIRONMENT" ]; then
    perl -0pi -e 's/(module.exports.environment\s*=\s*[\x27\x60]?)[.\d\w]*/${1}'"$ENVIRONMENT"'/igs' $CONFIG_FILE
fi
if [ ! -z "$DOMAIN" ]; then
    perl -0pi -e 's/(module.exports.user_from_host\s*=\s*[\x27\x60]).*(?=\$)/${1}^(.*)\\\\.'"${DOMAIN//\./\\\\\\\\.}"'/igs' $CONFIG_FILE
fi
perl -0pi -e 's/(module.exports.redis_host\s*=\s*[\x27\x60]?)[.\d\w]*/${1}'"$REDIS_HOST"'/igs' $CONFIG_FILE
perl -0pi -e 's/(module.exports.redis_port\s*=\s*[\x27\x60]?)[.\d\w]*/${1}'"$REDIS_PORT"'/igs' $CONFIG_FILE

perl -0pi -e 's/(module.exports.db_port\s*=\s*[\x27\x60]?)[.\d\w]*/${1}'"${DB_PORT:-5432}"'/igs' $CONFIG_FILE
if [ ! -z "$DB_HOST" ]; then
    perl -0pi -e 's/(module.exports.db_host\s*=\s*[\x27\x60]?)[.\d\w]*/${1}'"$DB_HOST"'/igs' $CONFIG_FILE
fi

node /usr/src/CartoDB-SQL-API-$SQL_VERSION/app.js $ENVIRONMENT
