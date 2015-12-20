#!/bin/bash

export RAILS_ENV=$ENVIRONMENT

CONFIG_FILE=/usr/src/cartodb-$CDB_VERSION/config/app_config.yml
DB_CONFIG_FILE=/usr/src/cartodb-$CDB_VERSION/config/database.yml

: ${REDIS_HOST:=localhost}
: ${REDIS_PORT:=6379}

# Wait for redis to be up
while ! nc -z $REDIS_HOST $REDIS_PORT ; do sleep 3; done

perl -0pi -e 's/(\s*http_port:\s*)[\d]*/${1}80/igs' $CONFIG_FILE
perl -0pi -e 's/(\s*https_port:\s*)[\d]*/${1}443/igs' $CONFIG_FILE
if [ ! -z "$DOMAIN" ]; then
    sed -ri 's/localhost.lan/'"$DOMAIN"'/' $CONFIG_FILE
fi
if [ ! -z "$SUBDOMAINLESS" ]; then
    sed -ri 's/^(\s*)subdomainless_urls:.*$/\1subdomainless_urls: true/' $CONFIG_FILE
    # remove dot from session_domain
    sed -ri 's/^(\s*session_domain:\s*)([\x27\x60])[.]?([:alnum:.]*)/\1\2\3/' $CONFIG_FILE
fi
perl -0pi -e 's/(\s*redis:.{0,100}host:\s*[\x27\x60])[.\d\w]*/${1}'"$REDIS_HOST"'/igs' $CONFIG_FILE
perl -0pi -e 's/(\s*redis:.{0,100}port:\s*)\d*/${1}'"$REDIS_PORT"'/igs' $CONFIG_FILE
if [ ! -z "$DB_PASSWORD" ]; then
    sed -ri 's/^(\s*)password:.*$/\1password: '"$DB_PASSWORD"'/' $DB_CONFIG_FILE
fi
if [ ! -z "$DB_PORT" ]; then
    sed -ri 's/^(\s*)port:.*$/\1port: '"$DB_PORT"'/' $DB_CONFIG_FILE
fi
if [ ! -z "$DB_HOST" ]; then
    sed -ri 's/^(\s*)host:.*$/\1host: '"$DB_HOST"'/' $DB_CONFIG_FILE
fi

cd /usr/src/cartodb-$CDB_VERSION
if [ ! -z "$CREATE_DB" ]; then
    bundle exec rake cartodb:db:setup SUBDOMAIN=${CDB_USER:-test} \
	EMAIL=${CDB_EMAIL:-example@example.com} PASSWORD=${CDB_PASS:-password}
    # bundle exec rake cartodb:db:set_user_private_tables_enabled[$CDB_USER,true]
    # bundle exec rake cartodb:db:set_user_quota[$CDB_USER,10240]
    # bundle exec rake cartodb:db:set_user_account_type[$CDB_USER,'[DEDICATED]']
    # bundle exec rake cartodb:db:set_unlimited_table_quota[$CDB_USER]
    # bundle exec rake cartodb:set_custom_limits_for_user[$CDB_USER,5000,500000000,10]
    # bundle exec rake cartodb:setup_max_import_file_size_based_on_disk_quota
    # bundle exec rake cartodb:setup_max_import_table_row_count_based_on_disk_quota
fi

/usr/local/bin/supervisord
