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

GEM_HOME=$PWD
source ${GEM_HOME}/set_env.sh >>/dev/null

write_log "------------------------------------------------------------------------------"
write_log "Cleaning up already existing image and container ... "
write_log "------------------------------------------------------------------------------"

run_cmd "${GEM_NEO4J_HOME}/stop.sh" "ignore_errors"

run_cmd "${GEM_API_HOME}/stop.sh" "ignore_errors"

write_log "------------------------------------------------------------------------------"
write_log "Cleaning up networks ... "
write_log "------------------------------------------------------------------------------"

run_cmd "docker network rm ${GEM_NETWORK}" "ignore_errors"

write_log "SUCCESS"

