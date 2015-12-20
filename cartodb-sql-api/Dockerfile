FROM ubuntu:12.04
MAINTAINER Alex Zvoleff <azvoleff@conservation.org>

ENV SQL_VERSION 1.24.0
ENV ENVIRONMENT production

# Get the add-apt-repository command
RUN apt-get update && apt-get install -y --no-install-recommends python-software-properties

RUN add-apt-repository -y ppa:cartodb/nodejs-010
RUN add-apt-repository -y ppa:cartodb/cairo

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
           build-essential checkinstall \
           nodejs \
           zip gdal-bin \ 
           zlib1g-dev libssl-dev libxml2-dev libxslt-dev libreadline6-dev libyaml-dev libffi-dev \
           curl \
           netcat \
           git \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://github.com/CartoDB/CartoDB-SQL-API/archive/$SQL_VERSION.tar.gz | tar -v -C /usr/src -xz

RUN cd /usr/src/CartoDB-SQL-API-$SQL_VERSION && npm install

RUN cd /usr/src/CartoDB-SQL-API-$SQL_VERSION/config/environments \
      && cp $ENVIRONMENT.js.example $ENVIRONMENT.js

COPY ./startup.sh /opt/startup.sh

EXPOSE 8080

CMD ["/bin/bash", "/opt/startup.sh"]
