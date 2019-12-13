#!/bin/bash

# execute $COMMAND [$DRYRUN=false]
# if command and dryrun=true are provided the command will be execuded
# if command and dryrun=false (or no second argument is provided)
# the function will only print the command the command to stdout
execute () {
  local exec_command=$1
  local flag_dryrun=${2:-$FLAG_DRYRUN}

  if [[ "${flag_dryrun}" == false ]]; then
     echo "+ ${exec_command}"
     (eval "${exec_command}")
  else
    echo "${exec_command}"
  fi
}
readonly -f execute
[ "$?" -eq "0" ] || return $?