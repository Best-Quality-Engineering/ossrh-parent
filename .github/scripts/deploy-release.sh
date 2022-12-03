#!/bin/bash -e
read_release_version() {
  RELEASE_VERSION="$(read_release_version)"
  RELEASE_BRANCH="release/${RELEASE_VERSION}"
}
read_default_branch_name() {
  DEFAULT_BRANCH_NAME=""
}
read_retain_release_branch() {
  RETAIN_RELEASE_BRANCH=false
}

read_release_version
read_default_branch_name
read_retain_release_branch

echo "Releasing ${RELEASE_VERSION}"
echo "Executing deploy goal for ${RELEASE_VERSION}"
if ! mvn -e -B -ntp -P ci -P ossrh clean deploy -Drevision="${RELEASE_VERSION}" -Dchangelist=""; then
  echo "Failure deploying release artifacts, aborting"
  exit 1
fi

echo "Configuring git to release"
git config --local user.name "Automaton"
git config --local user.email "bot@bestquality.engineering"

echo "Creating release branch: ${RELEASE_BRANCH}"
git checkout -b "${RELEASE_BRANCH}"

echo "Incrementing project revision"
mvn -e -B -ntp -P ci ci:increment-pom -Drevision="${RELEASE_VERSION}"

echo "Updating version references in project files"
mvn -e -B -ntp -P ci ci:replace-content -Drevision="${RELEASE_VERSION}" -Dchangelist=""

echo "Pushing ${RELEASE_BRANCH}"
git add -u .
git commit -m "Release ${RELEASE_VERSION} (build: ${GITHUB_RUN_ID})"
git push -u origin "${RELEASE_BRANCH}"

echo "Merging ${RELEASE_BRANCH} to ${DEFAULT_BRANCH_NAME}"
git fetch
git checkout "${DEFAULT_BRANCH_NAME}"
git merge "${RELEASE_BRANCH}"
git push -u origin "${DEFAULT_BRANCH_NAME}"

if [ ${RETAIN_RELEASE_BRANCH} -eq 0 ]; then
  echo "Deleting ${RELEASE_BRANCH}"
  git push origin --delete "${RELEASE_BRANCH}"
fi
