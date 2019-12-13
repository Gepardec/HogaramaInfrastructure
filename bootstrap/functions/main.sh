#!/bin/bash

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

  oc_setup ${git_branch} ${namespace} ${oc_admin_token} ${oc_cluster}

}

readonly -f main
[ "$?" -eq "0" ] || return $?