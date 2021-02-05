FROM virtualflybrain/vfb-prod:kb
#FROM virtualflybrain/docker-vfb-neo4j:enterprise

# from compose args
ARG CONF_REPO
ARG CONF_BRANCH

ENV CONF_BASE=/opt/conf_base
ENV CONF_DIR=${CONF_BASE}/config/knowledgebase

ENV NEOREADONLY=true

ENV NEO4J_dbms_memory_heap_maxSize=15G
ENV NEO4J_dbms_memory_heap_initial__size=1G
ENV NEO4J_dbms_read__only=true
#ENV NEO4J_dbms_memory_pagecache_size=20G

RUN mkdir -p /opt/VFB/backup

RUN apk update && apk add tar gzip curl wget git

RUN mkdir $CONF_BASE

###### REMOTE CONFIG ######
ARG CONF_BASE_TEMP=${CONF_BASE}/temp
RUN mkdir $CONF_BASE_TEMP
RUN cd "${CONF_BASE_TEMP}" && git clone --quiet ${CONF_REPO} && cd $(ls -d */|head -n 1) && git checkout ${CONF_BRANCH}
# copy inner project folder from temp to conf base
RUN cd "${CONF_BASE_TEMP}" && cd $(ls -d */|head -n 1) && cp -R . $CONF_BASE && cd $CONF_BASE && rm -r ${CONF_BASE_TEMP}

COPY loadKB.sh /opt/VFB/

RUN chmod +x /opt/VFB/loadKB.sh

ENTRYPOINT ["/opt/VFB/loadKB.sh"]
