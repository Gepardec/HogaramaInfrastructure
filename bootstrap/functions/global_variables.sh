#!/bin/sh

#######################
# READ ONLY VARIABLES #
#######################

readonly PROGNAME=`basename "$0"`
readonly TOPLEVEL_DIR=$( cd ${SCRIPT_DIR}/.. > /dev/null && pwd )

####################
# GLOBAL VARIABLES #
####################

FLAG_DRYRUN=false
FLAG_FORCE=false