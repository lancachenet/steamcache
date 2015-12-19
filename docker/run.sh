#!/bin/bash
. config.sh

docker run --name steamcache			\
	-v ${STEAMCACHE_DATA}:/var/www		\
	-v ${STEAMCACHE_LOGS}:/var/log/nginx	\
	-p ${STEAMCACHE_IP}:80:80 		\
	-p ${STEAMCACHE_IP}:53:53/udp		\
	-e HOSTIP=${HOST_IP}		\
	murraymint/steamcache:latest

