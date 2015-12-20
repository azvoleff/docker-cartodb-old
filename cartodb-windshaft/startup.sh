#!/bin/bash

CONFIG_FILE=/usr/src/Windshaft-cartodb-$WINDSHAFT_VERSION/config/environments/$ENVIRONMENT.js

: ${REDIS_HOST:=localhost}
: ${REDIS_PORT:=6379}

# Wait for redis to be up
while ! nc -z $REDIS_HOST $REDIS_PORT; do sleep 3; done

perl -0pi -e 's/(environment:\s*[\x27\x60])[.\d\w]*/${1}'"$ENVIRONMENT"'/igs' $CONFIG_FILE

# Default to listening on all interfaces so container links will work
perl -0pi -e 's/(,host:\s*[\x27\x60])[.\d\w]*/${1}'"${NODE_HOST:-0.0.0.0}"'/igs' $CONFIG_FILE

if [ ! -z "$DOMAIN" ]; then
    perl -0pi -e 's/(,user_from_host:\s*[\x27\x60]).*(?=\$)/${1}^(.*)\\\\.'"${DOMAIN//\./\\\\\\\\.}"'/igs' $CONFIG_FILE
fi
perl -0pi -e 's/(,redis:\s*\{.{0,100}host:\s*[\x27\x60])[.\d\w]*/${1}'"$REDIS_HOST"'/igs' $CONFIG_FILE
perl -0pi -e 's/(,redis:\s*\{.{0,100}port:\s*)\d*/${1}'"$REDIS_PORT"'/igs' $CONFIG_FILE
if [ ! -z "$DB_USER" ]; then
    perl -0pi -e 's/(,postgres:\s*\{.{0,100}user:\s*[\x27\x60])[.\d\w]*/${1}'"$DB_USER"'/igs' $CONFIG_FILE
fi
if [ ! -z "$DB_PASSWORD" ]; then
    perl -0pi -e 's/(,postgres:\s*\{.{0,100}password:\s*[\x27\x60])[.\d\w]*/${1}'"$DB_PASSWORD"'/igs' $CONFIG_FILE
fi
if [ ! -z "$DB_PORT" ]; then
    perl -0pi -e 's/(,postgres:\s*\{.{0,100}port:\s*)\d*/${1}'"$DB_PORT"'/igs' $CONFIG_FILE
fi
if [ ! -z "$DB_HOST" ]; then
    perl -0pi -e 's/(,postgres:\s*\{.{0,100}host:\s*[\x27\x60])[.\d\w]*/${1}'"$DB_HOST"'/igs' $CONFIG_FILE
fi

node /usr/src/Windshaft-cartodb-$WINDSHAFT_VERSION/app.js $ENVIRONMENT
