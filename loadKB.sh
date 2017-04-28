#!/bin/sh

cd /opt/VFB/backup/
curl -O http://data.virtualflybrain.org/archive/VFB-KB.tar.gz 
tar -xzvf /opt/VFB/backup/VFB-KB.tar.gz
chmod -R 777 /opt/VFB
/var/lib/neo4j/bin/neo4j-admin restore --from=/opt/VFB/backup/VFB-KB.db --force=true
rm -rf /opt/VFB/backup


sed -i s/read_only=false/read_only=${NEOREADONLY}/ ${NEOSERCONF} 

/docker-entrypoint.sh
