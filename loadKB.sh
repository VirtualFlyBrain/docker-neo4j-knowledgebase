#!/bin/sh

if [ -d /backup/KBW-RESTORE.db ]; then
  echo 'Resore KB from given backup'
  /var/lib/neo4j/bin/neo4j-admin restore --from=/backup/KBW-RESTORE.db --force=true && \
  cd /var/lib/neo4j && \
  rm -rf /backup/KBW-RESTORE.db;
fi
echo "set read only = ${NEOREADONLY} then launch neo4j service"
sed -i s/read_only=false/read_only=${NEOREADONLY}/ ${NEOSERCONF} && \
exec /docker-entrypoint.sh neo4j
