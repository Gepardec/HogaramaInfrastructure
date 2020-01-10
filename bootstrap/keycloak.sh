#!/bin/sh
    
readonly SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )
for functionFile in ${SCRIPT_DIR}/functions/*.sh;do source ${functionFile}; done

oc_setup() {
   # initial values
  local git_branch=${1}
  local namespace=${2}
  local oc_admin_token=${3}
  local oc_cluster=${4}

  oc_create_resource "admin" ${namespace} "resources/keycloak/operator-group.yml"
  oc_create_resource "admin" ${namespace} "resources/keycloak/subscription.yml"
  oc_create_resource "admin" ${namespace} "resources/keycloak/keycloak-crd.yml"
  oc_create_resource "admin" ${namespace} "resources/keycloak/realm-crd.yml"
  oc_create_resource "admin" ${namespace} "resources/keycloak/backup-crd.yml"
  oc_create_resource "admin" ${namespace} "resources/keycloak/client-crd.yml"

#  oc_create_resource "admin" ${namespace} "secrets/keycloak/keycloak_env.yml"
#  oc delete --config=/home/.admin secret keycloak-env -n ${namespace}
#  oc create --config=/home/.admin secret generic keycloak-env -n ${namespace} \
#    --from-file=${TOPLEVEL_DIR}/secrets/keycloak/keycloak_env.yml
#  oc_create_resource "admin" ${namespace} "resources/keycloak/dc.yml"
#  oc set env --config=/home/.admin dc/sso --from=secret/keycloak-env -n ${namespace} #TODO: überlegen ob export mit generierter DC und vorhandenen ENV Variablen. Problem: nachträgliches hinzufügen/ändern

}
readonly -f oc_setup
[ "$?" -eq "0" ] || return $?

main $@


