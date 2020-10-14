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
write_log "Cleaning up already existing image and container ... "
write_log "------------------------------------------------------------------------------"
run_cmd "docker container rm -f ${GEM_API_CONTAINER}" "ignore_errors"
run_cmd "docker image rm -f ${GEM_API_CONTAINER}" "ignore_errors"

write_log "SUCCESS"

