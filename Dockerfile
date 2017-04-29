FROM virtualflybrain/docker-vfb-neo4j:enterprise 

ENV NEOREADONLY=true

ENV NEO4J_dbms_memory_heap_maxSize=1G
ENV NEO4J_dbms_memory_heap_initial__size=100M

RUN mkdir -p /opt/VFB/backup

RUN apk update && apk add tar gzip curl

COPY loadKB.sh /opt/VFB/

RUN chmod +x /opt/VFB/loadKB.sh

ENTRYPOINT ["/opt/VFB/loadKB.sh"]
