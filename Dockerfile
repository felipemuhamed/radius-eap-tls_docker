From alpine:3.8
MAINTAINER Muhamed Avila <muhamed@cpqd.com.br>

RUN apk update && apk upgrade

RUN apk add --update freeradius freeradius-eap openssl make freeradius-sqlite freeradius-radclient freeradius-rest openssl-dev && \
    chgrp radius  /usr/sbin/radiusd && chmod g+rwx /usr/sbin/radiusd && \
    rm /var/cache/apk/* && \
    cd /etc/raddb/certs/ && \
    make ca.pem && \
    make ca.der && \
    make server.pem && \
    make client.pem && \
    openssl dhparam -check -text -5 512 -out dh

COPY default /etc/raddb/sites-enabled/default
COPY eap /etc/raddb/mods-enabled/eap

EXPOSE \
    1812/udp \
    1813/udp \
    18120

CMD ["radiusd", "-X"]