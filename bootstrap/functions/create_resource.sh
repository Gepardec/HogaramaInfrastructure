#!/bin/bash

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