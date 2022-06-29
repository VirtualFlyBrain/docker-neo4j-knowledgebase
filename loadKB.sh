#!/bin/bash

## get remote configs
echo "Sourcing remote config"
source ${CONF_DIR}/config.env

echo "set read only = ${NEOREADONLY} then launch neo4j service"
sed -i s/read_only=.*/read_only=${NEOREADONLY}/ ${NEOSERCONF} && \

if [ ! -d /data/databases/neo4j ]; then
  if [ ! -d /backup/KBW-RESTORE.db ]; then
    echo 'Resore KB from archive backup'
    cd /opt/VFB/backup/
    rm -rf /opt/VFB/backup/VFB-KB-4-2.tar.gz
    wget $KB_DATA 
    tar -xzvf VFB-KB-4-2.tar.gz
    mkdir -p /backup/
    mv KBW-RESTORE.db /backup/KBW-RESTORE.db
  fi
  if [ -d /backup/KBW-RESTORE.db ]; then
    echo 'Resore KB from given backup'
    /var/lib/neo4j/bin/neo4j-admin restore --from=/backup/KBW-RESTORE.db --force --database=neo4j
  fi
fi

echo -e '\nSTARTING VFB KB SERVER\n' >> /var/lib/neo4j/logs/query.log

#Output the query log to docker log:
tail -f /var/lib/neo4j/logs/query.log >/proc/1/fd/1 &

#clear auth from backup
rm -rf /data/dbms/auth

exec /docker-entrypoint.sh neo4j
