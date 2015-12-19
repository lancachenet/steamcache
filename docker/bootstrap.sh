#!/bin/bash

sed -i -e "s%{{ steamcache_ip }}%$HOSTIP%g" /etc/bind/steamcache/db.content_.steampowered.com
sed -i -e "s%{{ steamcache_ip }}%$HOSTIP%g" /etc/bind/steamcache/db.cs.steampowered.com

named -c /etc/bind/named.conf

/usr/sbin/nginx

sleep 2

cd /scripts
./watchlog.sh
