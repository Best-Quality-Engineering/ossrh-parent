#!/bin/bash -e
echo "Installing artifacts locally from ${GITHUB_REF_NAME}"
mvn -e -B -ntp clean tools.bestquality:ci-maven-plugin:expand-pom install -Dsha1="-${GITHUB_RUN_ID}"
