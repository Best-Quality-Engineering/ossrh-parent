#!/bin/bash -e
echo "Deploying OSSRH snapshot artifacts from ${GITHUB_REF_NAME}"
mvn -e -B -ntp -P ossrh -P ci clean deploy

