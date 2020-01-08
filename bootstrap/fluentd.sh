#!/bin/sh
    
readonly SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )
for functionFile in ${SCRIPT_DIR}/functions/*.sh;do source ${functionFile}; done

oc_setup() {
   # initial values
  local git_branch=${1}
  local namespace=${2}
  local oc_admin_token=${3}
  local oc_cluster=${4}

  oc delete --config=/home/.admin secret fluentd-secret -n ${namespace};
  oc create --config=/home/.admin secret generic fluentd-secret -n ${namespace} \
    --from-file=${TOPLEVEL_DIR}/secrets/fluentd/fluent.conf

  oc_create_resource "admin" ${namespace} "resources/fluentd/imagestream.yml"
  #oc_create_resource "admin" ${namespace} "resources/fluentd/pvc.yml"
  oc_create_from_template "admin" ${namespace} "resources/fluentd/buildconfig.yml" "--param GIT_BRANCH=${git_branch}"
  oc_create_resource "admin" ${namespace} "resources/fluentd/deploymentconfig.yml"
  oc_create_resource "admin" ${namespace} "resources/fluentd/service.yml"
}
readonly -f oc_setup
[ "$?" -eq "0" ] || return $?

main $@