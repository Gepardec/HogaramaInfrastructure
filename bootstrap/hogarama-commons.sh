#!/bin/sh

readonly SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )
for functionFile in ${SCRIPT_DIR}/functions/*.sh;do source ${functionFile}; done

oc_setup() {
   # initial values
  local git_branch=${1}
  local namespace=${2}
  local oc_admin_token=${3}
  local oc_cluster=${4}

  oc_create_resource "admin" ${namespace} "resources/hogarama-commons/operator-group.yml"
  oc_create_resource "admin" ${namespace} "resources/hogarama-commons/anyuid-builder-serviceaccount.yml"
  oc_create_resource "admin" ${namespace} "resources/hogarama-commons/hogajama-anyuid.yml"
  oc --kubeconfig=/home/.admin -n ${namespace} adm policy add-scc-to-user anyuid -z anyuid-builder
  oc --kubeconfig=/home/.admin -n ${namespace} policy add-role-to-user system:image-builder -z anyuid-builder
  oc --kubeconfig=/home/.admin -n ${namespace} adm policy add-scc-to-user anyuid -z hogajama-anyuid
}

main $@