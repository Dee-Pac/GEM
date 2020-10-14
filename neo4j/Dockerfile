FROM neo4j:4.0.0

# Install app dependencies
COPY cypher/*.cypher /tmp/
COPY import/*.csv /var/lib/neo4j/import/

RUN chmod 755 /tmp/*.cypher
RUN chmod 755 /var/lib/neo4j/import/*.csv

CMD ["neo4j"]
