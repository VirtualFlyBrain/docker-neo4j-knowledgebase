set -e
docker pull virtualflybrain/docker-neo4j-knowledgebase:neo2owl
docker run -p:7474:7474 -p 7687:7687 --env=NEO4J_AUTH=neo4j/neo --env=NEO4J_dbms_read__only=false --env=NEO4J_dbms_memory_heap_maxSize=6G --env=NEO4J_dbms_memory_heap_initial__size=1G virtualflybrain/docker-neo4j-knowledgebase:neo2owl
