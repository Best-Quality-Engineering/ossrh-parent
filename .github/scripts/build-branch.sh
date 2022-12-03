#!/bin/bash -e
echo "Installing artifacts locally from ${GITHUB_REF_NAME}"
mvn -e -B -ntp -P ci clean install -Dsha1="-${GITHUB_RUN_ID}"
