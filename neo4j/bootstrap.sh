#!/bin/sh

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
this_file=`basename $0`
this_script="$this_dir/$this_file"
user_args=$@
user_args_count=$#

echo ""
echo "-----------------------------------------------------------------------------------------------"
echo "-------  Executing [$this_script $user_agrs]  -------"
echo "-----------------------------------------------------------------------------------------------"
echo ""

source ${GEM_HOME}/set_env.sh >>/dev/null

write_log "------------------------------------------------------------------------------"
write_log "Checking container availability : [${GEM_NEO4J_CONTAINER}]"
write_log "------------------------------------------------------------------------------"

container_count=`docker inspect ${GEM_NEO4J_CONTAINER} | grep "running" | wc -l`
if [ $container_count -ne 1 ]; then
   write_log "Container not found [${GEM_NEO4J_CONTAINER}]"
   write_log "Please start the neo4j container first by executing [${GEM_HOME}/neo4j/start.sh]"
   exit 1
else
   write_log "------------------------------------------------------------------------------"
   write_log "Found live container [${GEM_NEO4J_CONTAINER}]. Proceeding with bootstrapping data ..."
   write_log "------------------------------------------------------------------------------"
fi

write_log "------------------------------------------------------------------------------"
write_log "Copying scripts to container ..."
write_log "------------------------------------------------------------------------------"

run_cmd "docker cp ${GEM_HOME}/neo4j/cypher/truncate.cypher gem_neo4j:/tmp"
run_cmd "docker cp ${GEM_HOME}/neo4j/cypher/load_csv.cypher gem_neo4j:/tmp"
run_cmd "docker cp ${GEM_HOME}/neo4j/cypher/create_nodes_and_relationships.cypher ${GEM_NEO4J_CONTAINER}:/tmp"


write_log "------------------------------------------------------------------------------"
write_log "Copying data to container ..."
write_log "------------------------------------------------------------------------------"
#for data_file in ${GEM_HOME}/neo4j/data/*.csv; 
#do 
#run_cmd "docker cp ${data_file} ${GEM_NEO4J_CONTAINER}:/var/lib/neo4j/import"
#run_cmd "docker exec ${GEM_NEO4J_CONTAINER} bash chmod 755 /var/lib/neo4j/import/${data_file}"
#done

write_log "Copying - Complete !"

sleep 3

write_log "------------------------------------------------------------------------------"
write_log "Truncating entire data in neo4j ..."
write_log "------------------------------------------------------------------------------"
run_cmd "docker exec ${GEM_NEO4J_CONTAINER} bash bin/cypher-shell -u neo4j -p test -f /tmp/truncate.cypher"

write_log "------------------------------------------------------------------------------"
write_log "Loading sample data in neo4j ..."
write_log "------------------------------------------------------------------------------"
run_cmd "docker exec ${GEM_NEO4J_CONTAINER} bash bin/cypher-shell -u neo4j -p test -f /tmp/load_csv.cypher"

write_log "------------------------------------------------------------------------------"
write_log "Building GEM data (nodes & relationships)..."
write_log "------------------------------------------------------------------------------"
run_cmd "docker exec ${GEM_NEO4J_CONTAINER} bash bin/cypher-shell -u neo4j -p test -f /tmp/create_nodes_and_relationships.cypher"

write_log "------------------------------------------------------------------------------"
write_log "Successfully bootstrapped neo4j docker container [${GEM_NEO4J_CONTAINER}]"
write_log "Accessing Docker Container : docker exec -it gem_neo4j bash"
write_log "Accessing Via browser : http://localhost:7474/browser/"
write_log "neo4j logs : ${GEM_HOME}/neo4j/logs/debug.log"
write_log "------------------------------------------------------------------------------"
