#!/bin/bash

####################### 
# READ ONLY VARIABLES #
#######################

readonly PROGNAME=`basename "$0"`
readonly SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
readonly TOPLEVEL_DIR=$( cd ${SCRIPT_DIR}/../.. > /dev/null && pwd )

#################### 
# GLOBAL VARIABLES #
####################

FLAG_DRYRUN=false

########## 
# SOURCE #
##########

for functionFile in ${TOPLEVEL_DIR}/bootstrap/functions/*.active;
  do source ${functionFile}
done

source ${TOPLEVEL_DIR}/bootstrap/functions/hogarama_create.options

###############
# INIT VALUES #
###############

FLAG_DRYRUN=""
FLAG_FORCE=""
FLAG_QUIET=""
FLAG_HELP=""
##########
# SCRIPT #
##########

main () {

  # getopts
  local opts=`getopt -o hfr:q --long help,force,dryrun,resource:,quiet -- "$@"`
  local opts_return=$?
  if [ ${opts_return} != 0 ]; then
      echo
      (>&2 echo "failed to fetch options via getopt")
      echo
      return ${opts_return}
  fi
  eval set -- "$opts"
  while true ; do
      case "$1" in
      --resource)
          resource=${2}
          shift 2
          ;;
      -f | --force)
          FLAG_FORCE=true
          shift
          ;;
      --dryrun)
          FLAG_DRYRUN=true
          shift
          ;;
      -q | --quiet)
        FLAG_QUIET=true
        shift
        ;;
      -h | --help)
        FLAG_HELP=true
        ;;
      *)
          break
          ;;
      esac
  done

  OPTS_NAME=OPTS_${resource^^}
  OPTIONS=${!OPTS_NAME}

  if [[ "x${OPTIONS}" = "x" ]]; then
    OPTIONS=${OPTS_DEFAULT}
  fi

  ## pipe through flags to underlying script ##
  if [[ "x${FLAG_FORCE}" != "x" ]]; then
    OPTIONS="${OPTIONS} --force"
  fi

  if [[ "x${FLAG_QUIET}" != "x" ]]; then
    OPTIONS="${OPTIONS} --quiet"
  fi

  if [[ "x${FLAG_DRYRUN}" != "x" ]]; then
    OPTIONS="${OPTIONS} --dryrun"
  fi

   if [[ "x${FLAG_HELP}" != "x" ]]; then
    OPTIONS="${OPTIONS} --help"
  fi

  set -e
  execute "docker run --rm -it \
    -v ${TOPLEVEL_DIR}:/mnt/hogarama \
    quay.io/openshift/origin-cli:latest \
    /mnt/hogarama/bootstrap/scripts/hogarama_create.sh --resource ${resource} ${OPTIONS}"
  set +e
}
 
main $@