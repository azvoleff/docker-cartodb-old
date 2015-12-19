#!/bin/bash

CONFIG_FILE=/usr/src/Windshaft-cartodb-$WINDSHAFT_VERSION/config/environments/$ENVIRONMENT.js

if [ ! -z "$DOMAIN" ]; then
    sed -ri 's/(,user_from_host:\s*\x27\^\(.*\)\\\\.)cartodb\\\\.com/\1'"${DOMAIN//\./\\\\\\\\.}"'/' $CONFIG_FILE
fi
if [ ! -z "$REDIS_HOST" ]; then
    perl -0pi -e 's/(,redis:\s*\{.{0,100}host:\s*[\x27\x60])[.\d\w]*/$1'"$REDIS_HOST"'/igs' $CONFIG_FILE
fi
if [ ! -z "$REDIS_PORT" ]; then
    perl -0pi -e 's/(,redis:\s*\{.{0,100}port:\s*)\d*/$1'"$REDIS_PORT"'/igs' $CONFIG_FILE
fi
if [ ! -z "$DB_USER" ]; then
    perl -0pi -e 's/(,postgres:\s*\{.{0,100}user:\s*[\x27\x60])[.\d\w]*/$1'"$DB_USER"'/igs' $CONFIG_FILE
fi
if [ ! -z "$DB_PASSWORD" ]; then
    perl -0pi -e 's/(,postgres:\s*\{.{0,100}password:\s*[\x27\x60])[.\d\w]*/$1'"$DB_PASSWORD"'/igs' $CONFIG_FILE
fi
if [ ! -z "$DB_PORT" ]; then
    perl -0pi -e 's/(,postgres:\s*\{.{0,100}port:\s*)\d*/$1'"$DB_PORT"'/igs' $CONFIG_FILE
fi
if [ ! -z "$DB_HOST" ]; then
    perl -0pi -e 's/(,postgres:\s*\{.{0,100}host:\s*[\x27\x60])[.\d\w]*/$1'"$DB_HOST"'/igs' $CONFIG_FILE
fi
