#!/bin/bash -e
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

while getopts ":v:m:d:" option; do
  case ${option} in
  v)
    RELEASE_VERSION="${OPTARG#v}"
    RELEASE_BRANCH="release/${RELEASE_VERSION}"
    ;;
  m)
    MAIN_BRANCH_NAME="${OPTARG}"
    ;;
  d)
    DELETE_RELEASE_BRANCH="${OPTARG}"
    ;;
  \?)
    echo "Invalid option: -${OPTARG}."
    exit 1
    ;;
  esac
done

echo "Releasing ${RELEASE_VERSION}"
echo "Executing deploy goal for ${RELEASE_VERSION}"
if ! mvn -e -B -ntp -P ossrh clean "${CI_MAVEN_PLUGIN}:expand-pom" deploy -Drevision="${RELEASE_VERSION}" -Dchangelist=""; then
  echo "Failure deploying release artifacts, aborting"
  exit 1
fi

echo "Configuring git to release"
git config --local user.name "Automaton"
git config --local user.email "bot@bestquality.engineering"

echo "Creating release branch: ${RELEASE_BRANCH}"
git checkout -b "${RELEASE_BRANCH}"

echo "Incrementing project revision"
mvn -e -B -ntp "${CI_MAVEN_PLUGIN}:increment-pom" -Drevision="${RELEASE_VERSION}"

echo "Updating version references in project files"
mvn -e -B -ntp "${CI_MAVEN_PLUGIN}:replace-content" -Drevision="${RELEASE_VERSION}" -Dchangelist=""

echo "Pushing ${RELEASE_BRANCH}"
git add -u .
git commit -m "Release ${RELEASE_VERSION} (build: ${GITHUB_RUN_ID})"
git push -u origin "${RELEASE_BRANCH}"

echo "Merging ${RELEASE_BRANCH} to ${MAIN_BRANCH_NAME}"
git fetch
git checkout "${MAIN_BRANCH_NAME}"
git merge "${RELEASE_BRANCH}"
git push -u origin "${MAIN_BRANCH_NAME}"

if [[ "${DELETE_RELEASE_BRANCH}" == "true" ]]; then
  echo "Deleting ${RELEASE_BRANCH}"
  git push origin --delete "${RELEASE_BRANCH}"
fi
