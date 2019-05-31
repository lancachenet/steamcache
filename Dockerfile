FROM alpine:latest
MAINTAINER LanCache.Net Team <team@lancache.net>

ENV STEAMCACHE_VERSION 6
ENV WEBUSER nginx

RUN	apk update			\
	&& apk add			\
		openssl			\
		nginx


COPY overlay/ /

RUN	chmod 755 /scripts/*			;\
	mkdir -m 755 -p /data/cache		;\
	mkdir -m 755 -p /data/info		;\
	mkdir -m 755 -p /data/logs		;\
	mkdir -m 755 -p /tmp/nginx/		;\
	chown -R ${WEBUSER}:${WEBUSER} /data/	;\
	mkdir -p /etc/nginx/sites-enabled	;\
	ln -s /etc/nginx/sites-available/steamcache.conf /etc/nginx/sites-enabled/steamcache.conf

VOLUME ["/data/logs", "/data/cache", "/var/www"]

EXPOSE 80

WORKDIR /scripts

ENV STEAMCACHE_IP 0.0.0.0

ENTRYPOINT ["/scripts/bootstrap.sh"]
