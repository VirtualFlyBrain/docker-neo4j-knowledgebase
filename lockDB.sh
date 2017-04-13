#!/bin/sh

sleep 10m && sed -i s/read_only=false/read_only=true/ ${NEOSERCONF} &

/docker-entrypoint.sh
