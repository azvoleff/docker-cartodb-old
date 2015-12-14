FROM        ubuntu:14.04
RUN         apt-get update && apt-get install -y redis-tools
EXPOSE      6379
ENTRYPOINT  ["/usr/bin/redis-cli -p 26379"]
