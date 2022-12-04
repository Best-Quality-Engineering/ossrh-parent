#!/bin/bash -e
mvn -e -B -ntp -X \
  -D documents="dfdfd" \
  -D documents.location="\${project.basedir}/README.md" \
  -D documents.encoding="utf-8" \
  -D documents.pattern="(?sm)(<artifactId>ci-maven-plugin<\/artifactId>\s+<version>).*?(<\/version>)" \
  -D documents.replacement="\$1\${project.version}\$2" \
  -D revision="${RELEASE_VERSION}" \
  -D changelist="" \
  tools.bestquality:ci-maven-plugin:0.0.19:replace-content
