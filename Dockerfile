FROM virtualflybrain/docker-vfb-neo4j:enterprise 

RUN mkdir -p /opt/VFB/backup

ADD http://data.virtualflybrain.org/archive/KBbackup.tar.gz /opt/VFB/backup/

RUN cd / && tar -xzvf /opt/VFB/backup/KBbackup.tar.gz && \
chmod -R 777 /opt/VFB && \
neo4j-admin restore --from=/opt/VFB/backup/graph.db-KBbackup --force=true

RUN sed -i s/read_only=false/read_only=true/ ${NEOSERCONF}
