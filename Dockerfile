FROM virtualflybrain/docker-vfb-neo4j:enterprise 

ENV NEOREADONLY=true

RUN mkdir -p /opt/VFB/backup

RUN apk update && apk add tar

COPY loadKB.sh /opt/VFB/

RUN chmod +x /opt/VFB/loadKB.sh

ENTRYPOINT ["/opt/VFB/loadKB.sh"]
