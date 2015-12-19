FROM nginx:latest
MAINTAINER Michael Smith <me@murray-mint.co.uk>

EXPOSE 80
EXPOSE 53/udp

ENV DEBIAN_FRONTEND		noninteractive

RUN	apt-get update &&		\
	apt-get install --assume-yes	\
		bind9			\
		wget

ADD https://raw.githubusercontent.com/murray-mint/steamcache/master/configs/bind/steamcache.conf /etc/bind/steamcache.conf
ADD https://raw.githubusercontent.com/murray-mint/steamcache/master/configs/bind/steamcache/db.content_.steampowered.com /etc/bind/steamcache/db.content_.steampowered.com
ADD https://raw.githubusercontent.com/murray-mint/steamcache/master/configs/bind/steamcache/db.cs.steampowered.com /etc/bind/steamcache/db.cs.steampowered.com
ADD https://raw.githubusercontent.com/murray-mint/steamcache/master/configs/bind/named.conf.options /etc/bind/named.conf.options
ADD https://raw.githubusercontent.com/murray-mint/steamcache/master/docker/nginx.conf /etc/nginx/nginx.conf
ADD https://raw.githubusercontent.com/murray-mint/steamcache/master/docker/bootstrap.sh	/scripts/bootstrap.sh
ADD https://raw.githubusercontent.com/murray-mint/steamcache/master/docker/config.sh /scripts/config.sh
ADD https://raw.githubusercontent.com/murray-mint/steamcache/master/docker/watchlog.sh /scripts/watchlog.sh

RUN	mkdir -p /var/log/nginx	;\
	mkdir -p /var/www/cache	;\
	echo "include \"/etc/bind/steamcache.conf\";" >> /etc/bind/named.conf.local

VOLUME ["/var/www", "/var/log/nginx"]


RUN	chmod +x /scripts/watchlog.sh	;\
	chmod +x /scripts/config.sh

WORKDIR /scripts
ENTRYPOINT ["/scripts/bootstrap.sh"]
