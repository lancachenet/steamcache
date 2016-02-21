#!/bin/sh
set -e

. /scripts/config.sh

/usr/sbin/nginx -t

/usr/sbin/nginx

/scripts/watchlog.sh
