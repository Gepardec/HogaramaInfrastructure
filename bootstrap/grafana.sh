#!/bin/sh
    
readonly SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )
for functionFile in ${SCRIPT_DIR}/functions/*.sh;do source ${functionFile}; done

oc_setup() {
   # initial values
  local git_branch=${1}
  local namespace=${2}
  local oc_admin_token=${3}
  local oc_cluster=${4}

  oc_create_resource "admin" ${namespace} "resources/grafana/grafana-configmap.yml"
  oc_create_resource "admin" ${namespace} "resources/grafana/imagestream.yml"
  #oc_create_resource "admin" ${namespace} "resources/grafana/pvc.yml"
  oc_create_resource "admin" ${namespace} "resources/grafana/grafana-deploymentconfig.yml"
  oc_create_resource "admin" ${namespace} "resources/grafana/service.yml"
  oc_create_resource "admin" ${namespace} "resources/grafana/route.yml"
#  oc_create_resource "admin" ${namespace} "resources/grafana/grafana-subscription.yml"
#  oc_create_resource "admin" ${namespace} "resources/grafana/crd.yml"
}
readonly -f oc_setup
[ "$?" -eq "0" ] || return $?

main $@