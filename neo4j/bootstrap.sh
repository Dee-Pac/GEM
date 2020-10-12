#!/bin/bash

export GEM_HOME=$PWD
export GEM_NEO4J_CONTAINER=gem_neo4j

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
