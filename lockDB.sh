#!/bin/bash

sleep 10m && sed -i s/read_only=false/read_only=true/ ${NEOSERCONF} &

/bin/sh /docker-entrypoint.sh
