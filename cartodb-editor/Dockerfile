FROM ubuntu:12.04
MAINTAINER Alex Zvoleff <azvoleff@conservation.org>

# Version of CartoDB Editor
ENV CDB_VERSION 3.11.0
# Version of CartoDB SQL API
ENV SQL_VERSION 1.24.0
# Version of CartoDB.js
ENV CDBJS_VERSION 3.15.3

ENV PG_MAJOR 9.3
ENV ENVIRONMENT production

# Set UTF8 locale
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
      && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# Get the add-apt-repository command
RUN apt-get update && apt-get install -y --no-install-recommends python-software-properties

RUN add-apt-repository -y ppa:cartodb/nodejs-010
RUN add-apt-repository -y ppa:cartodb/postgresql-$PG_MAJOR
RUN add-apt-repository -y ppa:cartodb/gis

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
           autoconf binutils-doc bison build-essential flex \
           curl \
           gdal-bin libgdal-dev libgdal1h libgdal1-dev \
           git \
           imagemagick unp zip \
           libjson0 libjson0-dev python-simplejson \
           libgeos-c1v5 libgeos-dev \
           libxml2-dev \
           liblwgeom-2.1.8 \
           nodejs \
           ogr2ogr2-static-bin \
           libreadline-dev openssl libncurses5-dev libgdbm-dev \
           zlib1g-dev libssl-dev libxml2-dev libxslt-dev libreadline6-dev libyaml-dev libffi-dev \
           libpq5 libpq-dev \
           libicu-dev \
           netcat \
           postgresql-client-$PG_MAJOR \
           postgresql-server-dev-$PG_MAJOR \
           proj proj-bin proj-data libproj-dev \
           python-dev python-pip \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

# Setup Ruby
RUN curl -sSL https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz | tar -v -C /usr/src -xz \
      && cd /usr/src/ruby-install-0.5.0 \
      && make install \
      && ruby-install ruby 1.9.3 -- --disable-install-rdoc

ENV PATH /opt/rubies/ruby-1.9.3-p547/bin:$PATH

RUN gem install bundler

# Download cartodb and submodules
RUN curl -sSL https://github.com/CartoDB/cartodb/archive/v$CDB_VERSION.tar.gz | tar -v -C /usr/src -xz \
      && curl -sSL https://github.com/CartoDB/cartodb.js/archive/$CDBJS_VERSION.tar.gz | tar -v -C /usr/src/cartodb-$CDB_VERSION/lib/assets/javascripts/cdb -xz --strip-components=1 \
      && curl -sSL https://github.com/CartoDB/CartoDB-SQL-API/archive/$SQL_VERSION.tar.gz | tar -v -C /usr/src/cartodb-$CDB_VERSION/lib/sql -xz --strip-components=1 \
      && curl -sSL https://github.com/CartoDB/cartodb.css/archive/d6e8f1579043b951f76c0c032a4afa4508edbb05.tar.gz | tar -v -C /usr/src/cartodb-$CDB_VERSION/app/assets/stylesheets/old_common -xz --strip-components=1

RUN cd /usr/src/cartodb-$CDB_VERSION && RAILS_ENV=$ENVIRONMENT bundle install

RUN cd /usr/src/cartodb-$CDB_VERSION && npm install

ENV CPATH /usr/include/gdal/
RUN cd /usr/src/cartodb-$CDB_VERSION && pip install -r python_requirements.txt

RUN cd /usr/src/cartodb-$CDB_VERSION/config \
      && cp grunt_production.json.sample grunt_production.json

# Add grunt to path to avoid "grunt command not found" error
ENV PATH $PATH:/usr/src/cartodb-$CDB_VERSION/node_modules/grunt-cli/bin

# Ensure compass gem is found
#RUN gem source -a http://rubygems.org

RUN cd /usr/src/cartodb-$CDB_VERSION \
      && RAILS_ENV=$ENVIRONMENT bundle exec grunt --environment $ENVIRONMENT

RUN cd /usr/src/cartodb-$CDB_VERSION/config \
      && cp app_config.yml.sample app_config.yml \
      && cp database.yml.sample database.yml

# Install supervisor from pip to get newest version
RUN pip install supervisor
COPY supervisord.conf /etc/supervisord.conf
COPY ./startup.sh /opt/startup.sh

EXPOSE 80

CMD ["/bin/bash", "/opt/startup.sh"]
