#!/bin/bash

readonly SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )
for functionFile in ${SCRIPT_DIR}/functions/*.sh;do source ${functionFile}; done

oc_setup() {
   # initial values
  local git_branch=${1}
  local namespace=${2}
  local oc_admin_token=${3}
  local oc_cluster=${4}

  oc_create_resource "admin" ${namespace} "resources/prometheus/prometheus-subscription.yml"

  oc delete --config=/home/.admin secret prometheus-scrape-config -n ${namespace};
  oc create --config=/home/.admin -n ${namespace} secret generic prometheus-scrape-config --from-file=${TOPLEVEL_DIR}/secrets/prometheus/scrape-config.yml
  
  oc_create_resource "admin" ${namespace} "resources/prometheus/crd.yml"
  oc_create_resource "admin" ${namespace} "resources/prometheus/route.yml"
}

main $@