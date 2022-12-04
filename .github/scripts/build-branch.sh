#!/bin/bash -e
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo "Installing artifacts locally from ${GITHUB_REF_NAME}"
mvn -e -B -ntp "${CI_MAVEN_PLUGIN}:expand-pom" install -Dsha1="-${GITHUB_RUN_ID}"
