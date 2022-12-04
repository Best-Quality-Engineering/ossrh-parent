#!/bin/bash -e
echo "Deploying OSSRH snapshot artifacts from ${GITHUB_REF_NAME}"
mvn -e -B -ntp -P ossrh clean tools.bestquality:ci-maven-plugin:expand-pom deploy

