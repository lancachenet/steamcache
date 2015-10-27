#!/bin/bash
. config.sh
docker run --name steamcache -v ${STEAMCACHE_DATA}:/var/www -v ${STEAMCACHE_LOGS}:/var/log/nginx -d -p ${STEAMCACHE_IP}:80:80 murraymint/steamcache:latest
