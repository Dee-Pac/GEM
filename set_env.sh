#!/bin/sh

echo "------------------------------------------------------------------------------"
echo "Setting Global reusable functions ..."
echo "------------------------------------------------------------------------------"
echo "check_error"
echo "run_cmd"
echo "write_log"
echo "------------------------------------------------------------------------------"
echo ""

#----------------------------function will check for error code & exit if failure, else proceed further----------------------------#

#usage : check_error <$?> <custom_error_code>
#Example: Check_error < pass $? from the shell command > < Custom Message for errorcode -gt 0 >

check_error()
{
	cmd_error_code=$1
	custom_message=$2
	if  [ ${cmd_error_code} -gt 0 ]; then
	  write_log "Error    | Stage |  ${custom_message}"
	  exit ${cmd_error_code}
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

echo "------------------------------------------------------------------------------"
echo "Setting Global Environment Variables ..."
echo "------------------------------------------------------------------------------"

export GEM_HOME=$PWD
export GEM_NEO4J_HOME=${GEM_HOME}/neo4j
export GEM_API_HOME=${GEM_HOME}/api

export GEM_NETWORK=gem_net
export GEM_NEO4J_CONTAINER=gem_neo4j
export GEM_NEO4J_VERSION=latest
export GEM_API_CONTAINER=gem_api

export GEM_NEO4J_USER=neo4j
export GEM_NEO4J_PASSWORD=test

export NEO4J_MESSAGE="---------------------- NEO4J Docker Environment ------------------------------"
export NEO4J_MESSAGE="${NEO4J_MESSAGE}\nSuccessfully Launched neo4j docker container [${GEM_NEO4J_CONTAINER}]"
export NEO4J_MESSAGE="${NEO4J_MESSAGE}\nAccessing Docker Container : docker exec -it ${GEM_NEO4J_CONTAINER} bash"
export NEO4J_MESSAGE="${NEO4J_MESSAGE}\nAccessing Via browser : http://localhost:7474/browser/"
export NEO4J_MESSAGE="${NEO4J_MESSAGE}\nneo4j logs : ${GEM_HOME}/neo4j/logs/debug.log"
export NEO4J_MESSAGE="${NEO4J_MESSAGE}\n------------------------------------------------------------------------------"

export API_MESSAGE="----------------------- GraphQL Docker Environment ---------------------------"
export API_MESSAGE="${API_MESSAGE}\nSuccessfully Launched GraphQL docker container [${GEM_API_CONTAINER}]"
export API_MESSAGE="${API_MESSAGE}\nAccessing Docker Container : docker exec -it ${GEM_API_CONTAINER} bash"
export API_MESSAGE="${API_MESSAGE}\nAccessing Via browser : http://localhost:3000"
export API_MESSAGE="${API_MESSAGE}\n------------------------------------------------------------------------------"

echo "GEM_HOME=$PWD"
echo "GEM_NEO4J_HOME=${GEM_NEO4J_HOME}"
echo "GEM_API_HOME=${GEM_API_HOME}"
echo "GEM_NETWORK=${GEM_NETWORK}"
echo "GEM_NEO4J_CONTAINER=${GEM_NEO4J_CONTAINER}"
echo "GEM_NEO4J_VERSION=${GEM_NEO4J_VERSION}"
echo "GEM_API_CONTAINER=${GEM_API_CONTAINER}"
echo "GEM_NEO4J_USER=${GEM_NEO4J_USER}"
echo "GEM_NEO4J_PASSWORD=${GEM_NEO4J_PASSWORD}"
echo "------------------------------------------------------------------------------"
echo ""
