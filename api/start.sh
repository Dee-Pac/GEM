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
export GEM_NODE_CONTAINER=gem_node

cd ${GEM_HOME}/api

write_log "Present Working Directory : ${PWD}"

write_log "------------------------------------------------------------------------------"
write_log "Cleaning up already existing image and container ... "
write_log "------------------------------------------------------------------------------"
run_cmd "docker container rm -f ${GEM_NODE_CONTAINER}"
run_cmd "docker image rm -f ${GEM_NODE_CONTAINER}"

write_log "------------------------------------------------------------------------------"
write_log "Building docker image ... "
write_log "------------------------------------------------------------------------------"
run_cmd "docker build -t ${GEM_NODE_CONTAINER} -f Dockerfile ."

write_log "------------------------------------------------------------------------------"
write_log "Starting GEM container [${GEM_NODE_CONTAINER}]..."
write_log "------------------------------------------------------------------------------"

run_cmd "docker run \
    --network ${GEM_NETWORK} \
    --hostname ${GEM_NODE_CONTAINER} \
    -d \
    --rm \
    -p8080:8080 \
    -p3000:3000 \
    --name ${GEM_NODE_CONTAINER} \
    ${GEM_NODE_CONTAINER}
"

write_log "------------------------------------------------------------------------------"
write_log "Sleeping for few seconds to start [${GEM_NODE_CONTAINER}]..."
write_log "------------------------------------------------------------------------------"

sleep 5

container_count=`docker inspect ${GEM_NODE_CONTAINER} | grep "running" | wc -l`
if [ $container_count -ne 1 ]; then
   write_log "Container not found [${GEM_NODE_CONTAINER}]"
   write_log "Failed to launch ${GEM_NODE_CONTAINER}"
   exit 1
else
   write_log "------------------------------------------------------------------------------"
   write_log "Successfully Launched GraphQL docker container [${GEM_NODE_CONTAINER}]"
   write_log "Accessing Docker Container : docker exec -it ${GEM_NODE_CONTAINER} bash"
   write_log "Accessing Via browser : http://localhost:3000"
   write_log "------------------------------------------------------------------------------"
fi

