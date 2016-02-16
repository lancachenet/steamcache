FROM nginx:latest
MAINTAINER SteamCache.Net Team <team@steamcache.net>

ENV STEAMCACHE_VERSION 5

COPY overlay/ /

RUN	chmod 755 /scripts/*			;\
	mkdir -m 755 -p /data/cache		;\
	mkdir -m 755 -p /data/info		;\
	mkdir -m 755 -p /data/logs		;\
	mkdir -m 755 -p /tmp/nginx/		;\
	chown -R www-data:www-data /data/	;\
	mkdir -p /etc/nginx/sites-enabled	;\
	ln -s /etc/nginx/sites-available/steamcache.conf /etc/nginx/sites-enabled/steamcache.conf

VOLUME ["/data/logs", "/data/cache", "/var/www"]

EXPOSE 80

WORKDIR /scripts

ENV STEAMCACHE_IP 0.0.0.0
ENV HOST_IP 192.168.0.5

ENTRYPOINT ["/scripts/bootstrap.sh"]
