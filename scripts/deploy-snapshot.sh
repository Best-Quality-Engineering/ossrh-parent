#!/bin/bash -e
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

echo "Deploying OSSRH snapshot artifacts from ${GITHUB_REF_NAME}"
mvn -e -B -ntp -P ossrh clean "${CI_MAVEN_PLUGIN}:expand-pom" deploy

