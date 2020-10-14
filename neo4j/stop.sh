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
write_log "Stopping container if already running [${GEM_NEO4J_CONTAINER}]..."
write_log "------------------------------------------------------------------------------"
run_cmd "docker stop ${GEM_NEO4J_CONTAINER}" "ignore_errors"

write_log "------------------------------------------------------------------------------"
write_log "Removing container if exists [${GEM_NEO4J_CONTAINER}]..."
write_log "------------------------------------------------------------------------------"
run_cmd "docker container rm -f ${GEM_NEO4J_CONTAINER}" "ignore_errors"

write_log "------------------------------------------------------------------------------"
write_log "Removing image if exists [${GEM_NEO4J_CONTAINER}]..."
write_log "------------------------------------------------------------------------------"
run_cmd "docker image rm -f ${GEM_NEO4J_CONTAINER}" "ignore_errors"
