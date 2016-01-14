#!/bin/bash

. /scripts/config.sh

cp /etc/bind/steamcache/template.db.content_.steampowered.com /etc/bind/steamcache/db.content_.steampowered.com
cp /etc/bind/steamcache/template.db.cs.steampowered.com /etc/bind/steamcache/db.cs.steampowered.com

sed -i -e "s%{{ steamcache_ip }}%$HOSTIP%g" /etc/bind/steamcache/db.content_.steampowered.com
sed -i -e "s%{{ steamcache_ip }}%$HOSTIP%g" /etc/bind/steamcache/db.cs.steampowered.com

service bind9 start
service nginx restart

/scripts/watchlog.sh
