FROM virtualflybrain/docker-vfb-neo4j:enterprise 

ENV NEOREADONLY=true

RUN mkdir -p /opt/VFB/backup

ADD http://data.virtualflybrain.org/archive/VFB-KB.tar.gz /opt/VFB/backup/

RUN /var/lib/neo4j/bin/neo4j start && sleep 1m && \ 
cd /opt/VFB/backup/ && tar -xzvf /opt/VFB/backup/VFB-KB.tar.gz && \
chmod -R 777 /opt/VFB && \
/var/lib/neo4j/bin/neo4j-admin restore --from=/opt/VFB/backup/VFB-KB.db --force=true

RUN sed -i s/read_only=false/read_only=${NEOREADONLY}/ ${NEOSERCONF} 
