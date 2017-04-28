FROM virtualflybrain/docker-vfb-neo4j:enterprise 

ENV NEOREADONLY=true

RUN mkdir -p /opt/VFB/backup

COPY loadKB.sh /opt/VFB/

RUN chmod +x /opt/VFB/loadKB.sh

ENTRYPOINT ['/bin/sh -c','/opt/VFB/loadKB.sh']
