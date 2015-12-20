#!/bin/bash

IFS=', ' read -r -a redis_hosts <<< "$REDIS_HOSTS"

n=0
for i in ${redis_hosts[@]}; do
    echo '  server redis'"${n}"' '"${redis_hosts[$n]}"':6379 check inter 1s' >> /usr/local/etc/haproxy/haproxy.cfg
    let n=n+1
done

haproxy -f /usr/local/etc/haproxy/haproxy.cfg
