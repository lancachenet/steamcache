#!/bin/bash

############################
#
# This script will show the log from the Steam Cache in colours
# (Red: Remote, Green: Local, Orange: other).
# Where it can, it will try and find the name of the depot being
# downloaded and show that as part of the output.
#
############################

. config.sh

getGameName() {

  if ! [ -s ${STEAMCACHE_DEPOTCACHE}/${1} ]; then
    wget -O ${STEAMCACHE_DEPOTCACHE}/$1 https://steamdb.info/depot/$1/ >/dev/null 2>&1
  fi

    #Allows for when something goes wrong with the name.
  G=`cat ${STEAMCACHE_DEPOTCACHE}/${1} | grep "\<h1" | sed 's/.*header-title\">//;s/<\/h1.*//'`

  echo $G
}

mkdir -p ${STEAMCACHE_DEPOTCACHE}

tail -f ${STEAMCACHE_LOGS}/steampowered.com-access.log | while read LINE; do

  GAMEID=`echo ${LINE} | sed 's/.*\/depot\/\([0-9]*\)\/.*/\1/'`
  GAMENAME=`getGameName ${GAMEID}`

  echo "(${GAMENAME}) ${LINE}" | awk '
    /LOCAL/ {print "\033[32m" $0 "\033[39m"}
    /REMOTE/ {print "\033[31m" $0 "\033[39m"}
    /OTHER/ {print "\033[33m" $0 "\033[39m"}
  '
done

