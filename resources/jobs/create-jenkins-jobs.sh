#!/bin/bash
# create and update all jobs
set -e

build_jenkins_jobs() {
    # Hacky but wait for 20 seconds before attempting to
    # work with the Jenkins API
    sleep 80s

    for job in /var/jenkins_job_templates/*; do

        local jobname=$(basename ${job})
        local config=/var/jenkins_job_templates/${jobname}/config.xml

        # create a new job for each directory under workspace/jobs
        curl -XPOST -s -o /dev/null \
        -d @${config} \
        -H 'Content-Type: application/xml' \
        http://127.0.0.1:8080/createItem?name=${jobname}
    done
}

build_jenkins_jobs
