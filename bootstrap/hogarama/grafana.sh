#!/bin/bash

function grafana () {
  local git_branch=${1}
  local namespace=${2}
  local oc_admin_token=${3}
  local oc_cluster=${4}

  grafana-operator ${git_branch} ${namespace} ${oc_admin_token} ${oc_cluster}
  
  oc-create-resource "admin" ${namespace} "resources/grafana/grafana-configmap.yml"
  oc-create-resource "admin" ${namespace} "resources/grafana/imagestream.yml"
  #oc-create-resource "admin" ${namespace} "resources/grafana/pvc.yml"
  oc-create-resource "admin" ${namespace} "resources/grafana/grafana-deploymentconfig.yml"
  oc-create-resource "admin" ${namespace} "resources/grafana/service.yml"
  oc-create-resource "admin" ${namespace} "resources/grafana/route.yml"
#  oc-create-resource "admin" ${namespace} "resources/grafana/grafana-subscription.yml"
#  oc-create-resource "admin" ${namespace} "resources/grafana/crd.yml"
}
readonly -f grafana
[ "$?" -eq "0" ] || return $?

function grafana-operator {
  local git_branch=${1}
  local namespace=${2}
  local oc_admin_token=${3}
  local oc_cluster=${4}

  oc-create-resource "admin" ${namespace} "resources/grafana/grafana-subscription.yml"
  oc-create-resource "admin" ${namespace} "resources/grafana/grafana-crd.yml"
  oc-create-resource "admin" ${namespace} "resources/grafana/grafana-dashboard.yml"
  oc-create-resource "admin" ${namespace} "resources/grafana/grafana-datasource.yml"

}
readonly -f grafana-operator
[ "$?" -eq "0" ] || return $?
