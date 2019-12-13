#!/bin/sh
    
readonly SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )
for functionFile in ${SCRIPT_DIR}/functions/*.sh;do source ${functionFile}; done

oc_setup() {
   # initial values
  local git_branch=${1}
  local namespace=${2}
  local oc_admin_token=${3}
  local oc_cluster=${4}

   oc delete --config=/home/.admin cm amq-configs -n ${namespace};
   oc create --config=/home/.admin cm amq-configs -n ${namespace} \
    --from-file=${TOPLEVEL_DIR}/configs/amq/bootstrap.xml \
    --from-file=${TOPLEVEL_DIR}/configs/amq/broker.xml \
    --from-file=${TOPLEVEL_DIR}/configs/amq/login.config \
    --from-file=${TOPLEVEL_DIR}/configs/amq/entrypoint.sh

  oc delete --config=/home/.admin secret amq-secrets -n ${namespace};
  oc create --config=/home/.admin secret generic amq-secrets -n ${namespace} \
    --from-file=${TOPLEVEL_DIR}/secrets/amq/broker.jks \
    --from-file=${TOPLEVEL_DIR}/secrets/amq/keycloak.json

  oc delete --config=/home/.admin secret amq-credentials -n ${namespace};
  oc create --config=home/.admin secret generic amq-credentials -n ${namespace} \
    --from-literal=AMQ_USER="amq" \
    --from-literal=AMQ_PASSWORD="amq@123"

  oc_create_from_template "admin" ${namespace} "resources/amq/imagestream.yml"
  oc_create_from_template "admin" ${namespace} "resources/amq/buildconfig.yml" "--param GIT_BRANCH=${git_branch}"
  oc_create_resource "admin" ${namespace} "resources/amq/deploymentconfig.yml"
  oc_create_resource "admin" ${namespace} "resources/amq/service.yml"
  oc_create_resource "admin" ${namespace} "resources/amq/route.yml"
}
readonly -f oc_setup
[ "$?" -eq "0" ] || return $?

main $@