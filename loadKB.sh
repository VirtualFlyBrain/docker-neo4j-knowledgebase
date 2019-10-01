#!/bin/sh

if [ ! -d /data/databases/graph.db ]; then
  if [ ! -d /backup/KBW-RESTORE.db ]; then
    echo 'Resore KB from archive backup'
    cd /opt/VFB/backup/
    rm /opt/VFB/backup/VFB-KB.tar.gz
    wget http://data.virtualflybrain.org/archive/VFB-KB.tar.gz 
    tar -xzvf VFB-KB.tar.gz
    mkdir -p /backup/KBW-RESTORE.db/
    find /opt/VFB/backup/ -name 'KBW-RESTORE.db' -exec cp -vr "{}" /backup/ +
    rm -rf /opt/VFB/backup/*
    cd -
  fi
fi

if [ -d /backup/KBW-RESTORE.db ]; then
  echo 'Resore KB from given backup'
  /var/lib/neo4j/bin/neo4j-admin restore --from=/backup/KBW-RESTORE.db --force=true
fi
echo "set read only = ${NEOREADONLY} then launch neo4j service"
sed -i s/read_only=.*/read_only=${NEOREADONLY}/ ${NEOSERCONF} && \

echo -e '\nSTARTING VFB KB SERVER\n' >> /var/lib/neo4j/logs/query.log

#Output the query log to docker log:
tail -f /var/lib/neo4j/logs/query.log >/proc/1/fd/1 &

#clear auth from backup
rm -rf /data/dbms/auth

exec /docker-entrypoint.sh neo4j
