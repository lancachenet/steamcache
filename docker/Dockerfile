FROM nginx:latest
MAINTAINER Michael Smith <me@murray-mint.co.uk>
EXPOSE 80
VOLUME ["/var/www", "/var/log/nginx"]
ADD https://raw.githubusercontent.com/murray-mint/steamcache/master/docker/nginx.conf /etc/nginx/nginx.conf
