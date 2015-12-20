#!/bin/bash

CONFIG_FILE=/usr/src/CartoDB-SQL-API-$SQL_VERSION/config/environments/$ENVIRONMENT.js

perl -0pi -e 's/(module.exports.environment\s*:\s*[\x27\x60])[.\d\w]*/$1'"$ENVIRONMENT"'/igs' $CONFIG_FILE
if [ ! -z "$ENVIRONMENT" ]; then
    perl -0pi -e 's/(module.exports.environment\s*=\s*[\x27\x60]?)[.\d\w]*/$1'"$ENVIRONMENT"'/igs' $CONFIG_FILE
fi
if [ ! -z "$DOMAIN" ]; then
    perl -0pi -e 's/(module.exports.user_from_host\s*=\s*[\x27\x60]).*(?=\$)/$1^(.*)\\\\.'"${DOMAIN//\./\\\\\\\\.}"'/igs' $CONFIG_FILE
fi
if [ ! -z "$REDIS_HOST" ]; then
    perl -0pi -e 's/(module.exports.redis_host\s*=\s*[\x27\x60]?)[.\d\w]*/$1'"$REDIS_HOST"'/igs' $CONFIG_FILE
fi
if [ ! -z "$REDIS_PORT" ]; then
    perl -0pi -e 's/(module.exports.redis_port\s*=\s*[\x27\x60]?)[.\d\w]*/$1'"$REDIS_PORT"'/igs' $CONFIG_FILE
fi
if [ ! -z "$DB_PORT" ]; then
    perl -0pi -e 's/(module.exports.db_port\s*=\s*[\x27\x60]?)[.\d\w]*/$1'"$DB_PORT"'/igs' $CONFIG_FILE
fi
if [ ! -z "$DB_HOST" ]; then
    perl -0pi -e 's/(module.exports.db_host\s*=\s*[\x27\x60]?)[.\d\w]*/$1'"$DB_HOST"'/igs' $CONFIG_FILE
fi
