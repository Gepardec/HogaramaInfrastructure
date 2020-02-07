#!/bin/bash

oc_create_from_template () {
  local token=${1}
  local namespace=${2}
  local file=${3}
  local param=${4}

  if ! execute "oc --kubeconfig=/home/.${token} process -f ${TOPLEVEL_DIR}/${file} -n ${namespace} ${param} | oc --kubeconfig=/home/.${token} create -n ${namespace} -f - 2> /dev/null"; then
    if ${FLAG_FORCE}; then
      execute "oc --kubeconfig=/home/.${token} process -f ${TOPLEVEL_DIR}/${file} -n ${namespace} ${param} | oc --kubeconfig=/home/.${token} delete -n ${namespace} --wait=true -f -"
      execute "oc --kubeconfig=/home/.${token} process -f ${TOPLEVEL_DIR}/${file} -n ${namespace} ${param} | oc --kubeconfig=/home/.${token} create -n ${namespace} -f -"
    else
      echo "It seems the resource(s) defined in \"${TOPLEVEL_DIR}/${file}\" already exists."
      echo "Do you really want to recreate the resource(s) from scratch?"
      read -p "Are you sure? [y/N]: " -r
      if [[ ${REPLY} =~ ^[Yy]$ ]]; then
        execute "oc --kubeconfig=/home/.${token} process -f ${TOPLEVEL_DIR}/${file} -n ${namespace} ${param} | oc --kubeconfig=/home/.${token} delete -n ${namespace} --wait=true -f -"
        execute "oc --kubeconfig=/home/.${token} process -f ${TOPLEVEL_DIR}/${file} -n ${namespace} ${param} | oc --kubeconfig=/home/.${token} create -n ${namespace} -f -"
      else
        echo "resource(s) unchanged"
      fi
    fi
  fi
}
readonly -f oc_create_from_template
[ "$?" -eq "0" ] || return $?