FROM nginx:latest
MAINTAINER SteamCache.Net Team <team@steamcache.net>

ENV STEAMCACHE_VERSION 4

RUN	DEBIAN_FRONTEND=noninteractive \
    apt-get update \
 && apt-get install --assume-yes \
		bind9 \
		wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY overlay/ /

RUN	chmod 755 /scripts/* ;\
	mkdir -m 755 -p /data/cache ;\
	mkdir -m 755 -p /data/info ;\
	mkdir -m 755 -p /data/logs ;\
	mkdir -m 755 -p /tmp/nginx/ ;\
	chown -R www-data:www-data /data/ ;\
	mkdir /etc/nginx/sites-enabled	;\
	ln -s /etc/nginx/sites-available/steamcache.conf /etc/nginx/sites-enabled/steamcache.conf

RUN echo "include \"/etc/bind/steamcache.conf\";" >> /etc/bind/named.conf.local

VOLUME ["/data/logs", "/data/cache", "/var/www"]

EXPOSE 80
EXPOSE 53/udp

WORKDIR /scripts

ENV STEAMCACHE_IP 0.0.0.0
ENV HOST_IP 192.168.0.5

ENTRYPOINT ["/scripts/bootstrap.sh"]
