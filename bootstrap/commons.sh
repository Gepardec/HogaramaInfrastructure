#!/bin/sh
    
readonly SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )
for functionFile in ${SCRIPT_DIR}/functions/*.sh;do source ${functionFile}; done

oc_setup() {
   # initial values
  local git_branch=${1}
  local namespace=${2}
  local oc_admin_token=${3}
  local oc_cluster=${4}

  oc_create_resource "admin" ${namespace} "resources/commons/jboss-eap/jboss-eap-7-is.json"
  oc_create_resource "admin" ${namespace} "resources/commons/openjdk/openjdk-8-is.json"
  oc_create_resource "admin" ${namespace} "resources/commons/redhat-sso/redhat-sso-7-is.json"

  oc_create_resource "admin" ${namespace} "resources/hogarama-commons/anyuid-builder-serviceaccount.yml"
  oc --config=/home/.admin -n ${namespace} adm policy add-scc-to-user anyuid -z anyuid-builder
  oc --config=/home/.admin -n ${namespace} policy add-role-to-user system:image-builder -z anyuid-builder
}
readonly -f oc_setup
[ "$?" -eq "0" ] || return $?

main $@