#!/bin/sh
set -e

. /scripts/config.sh

echo "Checking permissions (This may take a long time if the permissions are incorrect on large caches)..."
find /data \! -user ${WEBUSER} -exec chown ${WEBUSER}:${WEBUSER} '{}' +
echo "Done. Starting caching server."

/usr/sbin/nginx -t

/usr/sbin/nginx -g "daemon off;"
