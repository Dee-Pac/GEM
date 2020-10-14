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
write_log "Creating docker bridge network ${GEM_NETWORK}"
write_log "------------------------------------------------------------------------------"

#run_cmd "docker network rm -f ${GEM_NETWORK}"
run_cmd "docker network create ${GEM_NETWORK}" "ignore_errors"

run_cmd "sh ${GEM_HOME}/neo4j/stop.sh"

write_log "NEO4J Community Edition Docker details can be found here [https://neo4j.com/developer/docker-run-neo4j/]"
write_log "NEO4J Version [${GEM_NEO4J_VERSION}]"
write_log "GEM (Graph of Enterprise Metadata) home directory [$GEM_HOME]"
write_log "GEM neo4j container name [$GEM_NEO4J_CONTAINER]"

write_log "------------------------------------------------------------------------------"
write_log "Pulling docker image ... "
write_log "------------------------------------------------------------------------------"
run_cmd "docker pull neo4j:${GEM_NEO4J_VERSION}"

write_log "------------------------------------------------------------------------------"
write_log "Starting container [${GEM_NEO4J_CONTAINER}]..."
write_log "------------------------------------------------------------------------------"

run_cmd "docker run \
    --network ${GEM_NETWORK} \
    --hostname ${GEM_NEO4J_CONTAINER} \
    --name ${GEM_NEO4J_CONTAINER} \
    -p7474:7474 -p7687:7687 \
    -d \
    --rm \
    -v ${GEM_HOME}/neo4j/import:/var/lib/neo4j/import \
    -v ${GEM_HOME}/neo4j/logs:/logs \
    -v ${GEM_HOME}/neo4j/plugins:/plugins \
    --env NEO4J_AUTH=${GEM_NEO4J_USER}/${GEM_NEO4J_PASSWORD} \
    neo4j:${GEM_NEO4J_VERSION}
"

write_log "------------------------------------------------------------------------------"
write_log "Sleeping for few seconds to start [${GEM_NEO4J_CONTAINER}]..."
write_log "------------------------------------------------------------------------------"

sleep 5

container_count=`docker inspect ${GEM_NEO4J_CONTAINER} | grep "running" | wc -l`
if [ $container_count -ne 1 ]; then
   write_log "Container not found [${GEM_NEO4J_CONTAINER}]"
   write_log "Failed to launch ${GEM_NEO4J_CONTAINER}"
   exit 1
else
   echo "${NEO4J_MESSAGE}"
fi

