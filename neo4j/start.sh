#!/bin/bash

#----------------------------function will check for error code & exit if failure, else proceed further----------------------------#

#usage : check_error <$?> <custom_error_code>
#Example: Check_error < pass $? from the shell command > < Custom Message for errorcode -gt 0 >

check_error()
{
	cmd_error_code=$1
	custom_message=$2
	if  [ ${cmd_error_code} -gt 0 ]; then
	  write_log "Error    | Stage |  ${custom_message}"
	  # exit ${cmd_error_code}
	else
	  write_log "Success  | Stage | ${custom_message}"
	fi
}

#-----------------------------------Executes a Command--------------------------------------------------------#



#Usage : run_cmd < The command to execute > 

run_cmd()
{
       cmd=$1
       if [ -z $2 ]; then 
         fail_on_error="break_code"
       else
         fail_on_error=$2
       fi 
       write_log "Executing Command --> $1"
       $cmd
       error_code=$?
       if [ ! $fail_on_error = "ignore_errors" ]; then
           check_error $error_code "$cmd"
       fi
}

#----------------------------function will write the message to Console / Log File----------------------------#

#Usage : write_log < Whatever message you need to log >

write_log()
{
        msg=$1
        to_be_logged="$(date '+%Y-%m-%d %H:%M:%S') | $msg"
        echo ${to_be_logged}
}


export GEM_NETWORK=gem_net
export GEM_HOME=$PWD
export GEM_NEO4J_CONTAINER=gem_neo4j
export NEO4J_VERSION=4.0.0

write_log "------------------------------------------------------------------------------"
write_log "Creating docker bridge network ${GEM_NETWORK}"
write_log "------------------------------------------------------------------------------"

#run_cmd "docker network rm -f ${GEM_NETWORK}"
run_cmd "docker network create ${GEM_NETWORK}"

write_log "NEO4J Community Edition Docker details can be found here [https://neo4j.com/developer/docker-run-neo4j/]"
write_log "NEO4J Version [${NEO4J_VERSION}]"
write_log "GEM (Graph of Enterprise Metadata) home directory [$GEM_HOME]"
write_log "GEM neo4j container name [$GEM_NEO4J_CONTAINER]"

write_log "------------------------------------------------------------------------------"
write_log "Pulling docker image ... "
write_log "------------------------------------------------------------------------------"
run_cmd "docker pull neo4j:${NEO4J_VERSION}"

write_log "------------------------------------------------------------------------------"
write_log "Stopping container if already running [${GEM_NEO4J_CONTAINER}]..."
write_log "------------------------------------------------------------------------------"
run_cmd "docker stop ${GEM_NEO4J_CONTAINER}"

write_log "------------------------------------------------------------------------------"
write_log "Removing container if exists [${GEM_NEO4J_CONTAINER}]..."
write_log "------------------------------------------------------------------------------"
run_cmd "docker container rm -f ${GEM_NEO4J_CONTAINER}"

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
    --env NEO4J_AUTH=neo4j/test \
    neo4j:latest
"

write_log "------------------------------------------------------------------------------"
write_log "Sleeping for few seconds to start [${GEM_NEO4J_CONTAINER}]..."
write_log "------------------------------------------------------------------------------"

sleep 5

container_count=`docker inspect ${GEM_NEO4J_CONTAINER} | grep "running" | wc -l`
if [ $container_count -ne 1 ]; then
   write_log "Container not found [${GEM_NEO4J_CONTAINER}]"
   write_log "Failed to launch ${GEM_NEO4J_CONTAINER}"
   #exit 1
else
   write_log "------------------------------------------------------------------------------"
   write_log "Successfully Launched neo4j docker container [${GEM_NEO4J_CONTAINER}]"
   write_log "Accessing Docker Container : docker exec -it ${GEM_NEO4J_CONTAINER} bash"
   write_log "Accessing Via browser : http://localhost:7474/browser/"
   write_log "neo4j logs : ${GEM_HOME}/neo4j/logs/debug.log"
   write_log "------------------------------------------------------------------------------"
fi

