#!/bin/sh
    
readonly SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )
for functionFile in ${SCRIPT_DIR}/functions/*.sh;do source ${functionFile}; done

oc_setup() {
   # initial values
  local git_branch=${1}
  local namespace=${2}
  local oc_admin_token=${3}
  local oc_cluster=${4}

  oc_create_resource "admin" ${namespace} "resources/grafana/grafana-subscription.yml"
  oc_create_resource "admin" ${namespace} "resources/grafana/crd.yml"
  oc_create_resource "admin" ${namespace} "resources/grafana/grafana-dashboard.yml"
  oc_create_resource "admin" ${namespace} "resources/grafana/grafana-datasource.yml"

}
readonly -f oc_setup
[ "$?" -eq "0" ] || return $?

main $@