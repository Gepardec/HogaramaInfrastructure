#!/bin/sh
    
readonly SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )
for functionFile in ${SCRIPT_DIR}/functions/*.sh;do source ${functionFile}; done

oc_setup() {
   # initial values
  local git_branch=${1}
  local namespace=${2}
  local oc_admin_token=${3}
  local oc_cluster=${4}

  oc delete --config=/home/.admin secret mongodb-credentials -n ${namespace};
  oc create --config=/home/.admin secret generic mongodb-credentials -n ${namespace} \
    --from-literal=MONGODB_USER="hogajama" \
    --from-literal=MONGODB_PASSWORD="hogajama@mongodb" \
    --from-literal=MONGODB_DATABASE="hogajamadb" \
    --from-literal=MONGODB_ADMIN_PASSWORD="admin@mongodb"

  oc_create_resource "admin" ${namespace} "resources/mongodb/imagestream.yml"
  #oc_create_resource "admin" ${namespace} "resources/mongodb/pvc.yml"
  oc_create_resource "admin" ${namespace} "resources/mongodb/deploymentconfig.yml"
  oc_create_resource "admin" ${namespace} "resources/mongodb/service.yml"
}

main $@