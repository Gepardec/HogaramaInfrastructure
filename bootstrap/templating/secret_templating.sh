#!/bin/bash
# used in gepardec/j2cli container to template all secrets
for item in $(find ${RESOURCES_DIR} -name "*.j2"); do
    #target_file_name=$(basename ${item} .j2)
    target_file_name=${item%.j2}
    echo ${target_file_name}
    j2 --format=yaml --format=yaml  -o ${target_file_name} ${item} secrets/secrets.yml
    chmod 777 ${target_file_name}

done;