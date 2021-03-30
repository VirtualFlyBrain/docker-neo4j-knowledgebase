#!/bin/bash

## get remote configs
echo "Sourcing remote config"
source ${CONF_DIR}/config.env

if [ ! -d /data/databases/graph.db ]; then
  if [ ! -d /backup/KBW-RESTORE.db ]; then
    echo 'Resore KB from archive backup'
    cd /opt/VFB/backup/
    rm /opt/VFB/backup/VFB-KB-4-2.tar.gz
    wget ${KB_DATA}
    tar -xzvf *.tar.gz
    rm -rf /var/lib/neo4j/data/*
    cp -r databases /var/lib/neo4j/data/
    cp -r dbms /var/lib/neo4j/data/

    rm -rf /opt/VFB/backup/*
    cd -
  fi
  # if [ -d /backup/KBW-RESTORE.db ]; then
  #   echo 'Resore KB from given backup'
  #   # /var/lib/neo4j/bin/neo4j-admin restore --from=/backup/KBW-RESTORE.db --database=neo4j --force
  #   rm -r /var/lib/neo4j/data/.
  #   cp -r /backup/KBW-RESTORE.db/databases /var/lib/neo4j/data/
  #   cp -r /backup/KBW-RESTORE.db/dbms /var/lib/neo4j/data/
  #   # /var/lib/neo4j/bin/neo4j-admin restore --from=/backup/KBW-RESTORE.db --force=true
  #   echo 'Restore complete'
  # fi
fi

echo "set read only = ${NEOREADONLY} then launch neo4j service"
sed -i s/read_only=.*/read_only=${NEOREADONLY}/ ${NEOSERCONF} && \

echo 'Allow new neo4j2owl plugin to make changes..'
echo 'dbms.security.procedures.unrestricted=ebi.spot.neo4j2owl.*,apoc.*' >> ${NEOSERCONF}

echo -e '\nSTARTING VFB KB SERVER\n' >> /var/lib/neo4j/logs/query.log

#Output the query log to docker log:
tail -f /var/lib/neo4j/logs/query.log >/proc/1/fd/1 &

#clear auth from backup
rm -rf /data/dbms/auth

exec /docker-entrypoint.sh neo4j
