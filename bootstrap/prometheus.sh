#!/bin/sh
    
#######################
# READ ONLY VARIABLES #
#######################

readonly PROGNAME=`basename "$0"`
readonly SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )
readonly TOPLEVEL_DIR=$( cd ${SCRIPT_DIR}/.. > /dev/null && pwd )

####################
# GLOBAL VARIABLES #
####################

FLAG_DRYRUN=false
FLAG_FORCE=false

##########
# SCRIPT #
##########

usage_message () {
  echo """Usage:
    $PROGNAME [OPT ..]
    required
      --namespace)                   ... openshift project or kubernetes namespace
      --oc-admin-token)              ... token priveleged enough to execute oc new-project, e.g. admin role
      --oc-cluster)                  ... e.g. https://api.crc.testing:6443
      --git-branch)                  ... specify the git branch for oc resource references
    
    optional
      --dryrun)                      ... only print commands that would be executed
      -f | --force)                  ... recreate without prompt

    general
      -h | --help)                   ... print this help text
    """
}
# readonly definition of a function throws an error if another function 
# with the same name is defined a second time
readonly -f usage_message
[ "$?" -eq "0" ] || return $?

# execute $COMMAND [$DRYRUN=false]
# if command and dryrun=true are provided the command will be execuded
# if command and dryrun=false (or no second argument is provided) 
# the function will only print the command the command to stdout
execute () {
  local exec_command=$1
  local flag_dryrun=${2:-$FLAG_DRYRUN}

  if [[ "${flag_dryrun}" == false ]]; then
     echo "+ ${exec_command}"
     (eval "${exec_command}")
  else
    echo "${exec_command}"
  fi
}
readonly -f execute
[ "$?" -eq "0" ] || return $?

oc_create_resource () {
  local token=${1}
  local namespace=${2}
  local file=${3}

  if ! execute "oc --config=/home/.${token} create -f ${TOPLEVEL_DIR}/${file} -n ${namespace} 2> /dev/null"; then
    if ${FLAG_FORCE}; then
      execute "oc --config=/home/.${token} delete --wait=true -f ${TOPLEVEL_DIR}/${file} -n ${namespace}"
      execute "oc --config=/home/.${token} create -f ${TOPLEVEL_DIR}/${file} -n ${namespace}"
    else
      echo "It seems the resource(s) defined in \"${TOPLEVEL_DIR}/${file}\" already exists."
      echo "Do you really want to recreate the resource(s) from scratch?"
      read -p "Are you sure? [y/N]: " -r
      if [[ ${REPLY} =~ ^[Yy]$ ]]; then
        execute "oc --config=/home/.${token} delete --wait=true -f ${TOPLEVEL_DIR}/${file} -n ${namespace}"
        execute "oc --config=/home/.${token} create -f ${TOPLEVEL_DIR}/${file} -n ${namespace}"
      else
        echo "resource(s) unchanged"
      fi
    fi
  fi
}
readonly -f oc_create_resource
[ "$?" -eq "0" ] || return $?


oc_create_from_template () {
  local token=${1}
  local namespace=${2}
  local file=${3}
  local param=${4}

  if ! execute "oc --config=/home/.${token} process -f ${TOPLEVEL_DIR}/${file} -n ${namespace} ${param} | oc --config=/home/.${token} create -n ${namespace} -f - 2> /dev/null"; then
    if ${FLAG_FORCE}; then
      execute "oc --config=/home/.${token} process -f ${TOPLEVEL_DIR}/${file} -n ${namespace} ${param} | oc --config=/home/.${token} delete -n ${namespace} --wait=true -f -"
      execute "oc --config=/home/.${token} process -f ${TOPLEVEL_DIR}/${file} -n ${namespace} ${param} | oc --config=/home/.${token} create -n ${namespace} -f -"
    else
      echo "It seems the resource(s) defined in \"${TOPLEVEL_DIR}/${file}\" already exists."
      echo "Do you really want to recreate the resource(s) from scratch?"
      read -p "Are you sure? [y/N]: " -r
      if [[ ${REPLY} =~ ^[Yy]$ ]]; then
        execute "oc --config=/home/.${token} process -f ${TOPLEVEL_DIR}/${file} -n ${namespace} ${param} | oc --config=/home/.${token} delete -n ${namespace} --wait=true -f -"
        execute "oc --config=/home/.${token} process -f ${TOPLEVEL_DIR}/${file} -n ${namespace} ${param} | oc --config=/home/.${token} create -n ${namespace} -f -"
      else
        echo "resource(s) unchanged"
      fi
    fi
  fi
}
readonly -f oc_create_from_template
[ "$?" -eq "0" ] || return $?

main () {
  # initial values
  local git_branch=""
  local namespace=""
  local oc_admin_token=""
  local oc_cluster=""

  # getopts
  local opts=`getopt -o hf --long git-branch:,oc-admin-token:,oc-cluster:,namespace:,help,force,dryrun -- "$@"`
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
      --oc-admin-token)  
          oc_admin_token=$2
          shift 2
          ;;
      --oc-cluster) 
          oc_cluster=$2
          shift 2
          ;;
      --namespace)
          namespace=$2
          shift 2
          ;;
      --git-branch)
          git_branch=$2
          shift 2
          ;;
      -h | --help)
          usage_message
          exit 0
          ;;
      -f | --force)
          FLAG_FORCE=true
          shift
          ;;
      --dryrun)
          FLAG_DRYRUN=true
          shift
          ;;
      *)
          break
          ;;
      esac
  done
  # Verify that all required options are set
  # if [ -z "$VAR" ]; This will return true if a variable is unset or set to the empty string ("").
  if [ -z "${git_branch}" ] || [ -z "${namespace}" ] || [ -z "${oc_admin_token}" ] || [ -z "${oc_cluster}" ]; then
      echo
      (>&2 echo "please provide all required options")
      echo
      usage_message
      return 1
  fi

  oc --config=/home/.admin login --token=${oc_admin_token} --insecure-skip-tls-verify=true ${oc_cluster} > /dev/null

  if ! oc --config=/home/.admin get projects -o name | grep -E "${namespace}\$" > /dev/null; then
    if ${FLAG_FORCE}; then
      execute "oc --config=/home/.admin new-project ${namespace} > /dev/null"
    else
      echo "it seems the project \"${namespace}\" does not exist. Do you want to create it?"
      read -p "Are you sure? [y/N]: " -r
      if [[ ${REPLY} =~ ^[Yy]$ ]]; then
          execute "oc --config=/home/.admin new-project ${namespace} > /dev/null"
      else
        echo "project not created. Exiting"
        exit 0
      fi
    fi
  fi

  oc_create_resource "admin" ${namespace} "resources/prometheus/prometheus-subscription.yml"

  oc delete --config=/home/.admin secret prometheus-scrape-config -n ${namespace};
  oc create --config=/home/.admin -n ${namespace} secret generic prometheus-scrape-config --from-file=${TOPLEVEL_DIR}/secrets/prometheus/scrape-config.yml
  
  oc_create_resource "admin" ${namespace} "resources/prometheus/crd.yml"
  oc_create_resource "admin" ${namespace} "resources/prometheus/route.yml"
}

main $@