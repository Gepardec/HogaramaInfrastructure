#!/bin/bash

readonly SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )
for functionFile in ${SCRIPT_DIR}/functions/*.sh;do source ${functionFile}; done

oc_setup() {
   # initial values
  local git_branch=${1}
  local namespace=${2}
  local oc_admin_token=${3}
  local oc_cluster=${4}

  oc_create_resource "admin" ${namespace} "resources/hogajama/s2i-builder-maven-is.yml"
  oc_create_resource "admin" ${namespace} "resources/hogajama/maven-is.yml"
  oc_create_resource "admin" ${namespace} "resources/hogajama/hogajama-binary-is.yml"
  oc_create_resource "admin" ${namespace} "resources/hogajama/s2i-builder-maven-bc.yml"
  oc_create_resource "admin" ${namespace} "resources/hogajama/hogajama-binary-bc.yml"


}

main $@