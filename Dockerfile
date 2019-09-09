FROM virtualflybrain/docker-vfb-neo4j:enterprise

ENV NEOREADONLY=true

ENV NEO4J_dbms_memory_heap_maxSize=1G
ENV NEO4J_dbms_memory_heap_initial__size=100M
ENV NEO4J_dbms_read__only=true

RUN mkdir -p /opt/VFB/backup

RUN apk update && apk add tar gzip curl wget

COPY loadKB.sh /opt/VFB/
RUN wget -P /var/lib/neo4j/plugins https://github.com/VirtualFlyBrain/neo4j2owl/releases/download/1.1.19-PRE/neo4j2owl.jar 


RUN chmod +x /opt/VFB/loadKB.sh

ENTRYPOINT ["/opt/VFB/loadKB.sh"]
