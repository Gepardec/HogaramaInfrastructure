#!/bin/bash

# docker-j2cli
function docker-j2cli () {
  local command="docker run --rm -it -e TZ=Europe/Vienna -v ${TOPLEVEL_DIR}:/mnt gepardec/j2cli"
  echo "+ ${command} $@" && ${command} $@
}
readonly -f docker-j2cli
[ "$?" -eq "0" ] || return $?