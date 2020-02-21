#!/bin/bash

readonly RESOURCES_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../.. && pwd )
echo ${pwd}

# docker-j2cli
function docker-j2cli () {
  local command="docker run --rm -it -e TZ=Europe/Vienna -v ${RESOURCES_DIR}:/mnt gepardec/j2cli "
  echo "+ ${command} $@" && ${command} $@
}
readonly -f docker-j2cli

# docker-j2cli
function docker-j2cli-all () {
  local command="docker run --rm -it -e TZ=Europe/Vienna -v ${RESOURCES_DIR}:/mnt gepardec/j2cli bootstrap/templating/secret_templating.sh"
  echo "+ ${command} $@" && ${command} $@
}
readonly -f docker-j2cli-all

[ "$?" -eq "0" ] || return $?