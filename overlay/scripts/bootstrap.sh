#!/bin/bash

. /scripts/config.sh

service nginx restart

/scripts/watchlog.sh
