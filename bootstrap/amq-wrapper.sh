#!/bin/bash

set -e
ABOVE_SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && cd .. && pwd )

docker run --rm -it \
  -v ${ABOVE_SCRIPT_DIR}:/home/hogaramaInfra \
  gepardec/oc /home/hogaramaInfra/bootstrap/amq.sh \
    --oc-admin-token "gHepACLu_mUfAxhP3FvPsl4V_ZyPJYjG3BW8M3FKzVc" \
    --oc-cluster https://api.learningfriday.aws.openshift.gepardec.com:6443 \
    --namespace hogarama