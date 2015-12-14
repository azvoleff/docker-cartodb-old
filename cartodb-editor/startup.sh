#!/bin/bash

if [ ! -z "$DOMAIN" ]; then
    sed -ri 's/localhost.lan/'"$DOMAIN"'/' /usr/src/cartodb-$CDB_VERSION/config/app_config.yml
fi
if [ ! -z "$SUBDOMAINLESS" ]; then
    sed -ri 's/^(\s*)subdomainless_urls:.*$/\1subdomainless_urls: true/' /usr/src/cartodb-$CDB_VERSION/config/app_config.yml
    # remove dot from session_domain
    sed -ri 's/^(\s*session_domain:\s*)([\x27\x60])[.]?([:alnum:.]*)/\1\2\3/' /usr/src/cartodb-$CDB_VERSION/config/app_config.yml
fi
if [ ! -z "$REDIS_HOST" ]; then
    perl -0pi -e 's/(\s*redis:.{0,100}host:\s*[\x27\x60])[.\d\w]*/$1'"$REDIS_HOST"'/igs' /usr/src/cartodb-$CDB_VERSION/config/app_config.yml
fi
if [ ! -z "$REDIS_PORT" ]; then
    perl -0pi -e 's/(\s*redis:.{0,100}port:\s*)\d*/$1'"$REDIS_PORT"'/igs' /usr/src/cartodb-$CDB_VERSION/config/app_config.yml
fi
if [ ! -z "$DB_PASSWORD" ]; then
    sed -ri 's/^(\s*)password:.*$/\1password: '"$DB_PASSWORD"'/' /usr/src/cartodb-$CDB_VERSION/config/database.yml
fi
if [ ! -z "$DB_PORT" ]; then
    sed -ri 's/^(\s*)port:.*$/\1port: '"$DB_PORT"'/' /usr/src/cartodb-$CDB_VERSION/config/database.yml
fi
if [ ! -z "$DB_HOST" ]; then
    sed -ri 's/^(\s*)host:.*$/\1host: '"$DB_HOST"'/' /usr/src/cartodb-$CDB_VERSION/config/database.yml
fi

PORT=80
cd /usr/src/cartodb-$CDB_VERSION
#bundle exec script/restore_redis
#bundle exec script/resque > resque.log 2>&1 &
bundle exec rails server -p 80
