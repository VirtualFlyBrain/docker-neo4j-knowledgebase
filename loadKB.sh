#!/bin/sh

if [ ! -d /data/databases/graph.db ]; then
  if [ ! -d /backup/KBW-RESTORE.db ]; then
    echo 'Resore KB from archive backup'
    if [ -f /opt/VFB/backup/VFB-KB.tar.gz ]; then
      cd /opt/VFB/backup/
      tar -xzvf VFB-KB.tar.gz
      mv *.db* /backup/KBW-RESTORE.db
    fi
  fi
fi

if [ -d /backup/KBW-RESTORE.db ]; then
  echo 'Resore KB from given backup'
  /var/lib/neo4j/bin/neo4j-admin restore --from=/backup/KBW-RESTORE.db --force=true
fi
echo "set read only = ${NEOREADONLY} then launch neo4j service"
sed -i s/read_only=false/read_only=${NEOREADONLY}/ ${NEOSERCONF} && \
exec /docker-entrypoint.sh neo4j
