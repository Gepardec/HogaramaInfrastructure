#!/bin/bash

##########
# SCRIPT #
##########

usage_message () {
  echo """Usage:
    $PROGNAME [OPT ..]
    required
      --namespace)                   ... openshift project or kubernetes namespace
      --oc-admin-token)              ... token priveleged enough to execute oc new-project, e.g. admin role
      --oc-cluster)                  ... e.g. https://api.crc.testing:6443
      --git-branch)                  ... specify the git branch for oc resource references

    optional
      --dryrun)                      ... only print commands that would be executed
      -f | --force)                  ... recreate without prompt

    general
      -h | --help)                   ... print this help text
    """
}
# readonly definition of a function throws an error if another function
# with the same name is defined a second time
readonly -f usage_message
[ "$?" -eq "0" ] || return $?