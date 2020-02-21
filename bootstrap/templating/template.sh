#!/bin/bash
readonly CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
source ${CURRENT_DIR}/docker-j2cli.sh

docker-j2cli-all