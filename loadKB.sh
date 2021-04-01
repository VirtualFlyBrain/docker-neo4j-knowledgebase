#!/bin/bash

## get remote configs
echo "Sourcing remote config"
source ${CONF_DIR}/config.env

echo "set read only = ${NEOREADONLY} then launch neo4j service"
sed -i s/read_only=.*/read_only=${NEOREADONLY}/ ${NEOSERCONF} && \


echo -e '\nSTARTING VFB KB SERVER\n' >> /var/lib/neo4j/logs/query.log

#Output the query log to docker log:
tail -f /var/lib/neo4j/logs/query.log >/proc/1/fd/1 &

#clear auth from backup
rm -rf /data/dbms/auth

exec /docker-entrypoint.sh neo4j
