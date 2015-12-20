FROM haproxy:1.6.2
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

COPY ./startup.sh /opt/startup.sh

EXPOSE 6379

CMD ["/bin/bash", "/opt/startup.sh"]
