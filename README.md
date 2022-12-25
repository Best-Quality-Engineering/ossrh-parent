[![Install Status](https://github.com/Best-Quality-Engineering/ossrh-parent/actions/workflows/install-snapshot.yml/badge.svg)](https://github.com/Best-Quality-Engineering/ossrh-parent/actions/workflows/install-snapshot.yml)
[![Snapshot Status](https://github.com/Best-Quality-Engineering/ossrh-parent/actions/workflows/deploy-ossrh-snapshot.yml/badge.svg)](https://github.com/Best-Quality-Engineering/ossrh-parent/actions/workflows/deploy-ossrh-snapshot.yml)
[![Release Status](https://github.com/Best-Quality-Engineering/ossrh-parent/actions/workflows/deploy-ossrh-release.yml/badge.svg)](https://github.com/Best-Quality-Engineering/ossrh-parent/actions/workflows/deploy-ossrh-release.yml)
[![Maven Central](https://img.shields.io/maven-central/v/tools.bestquality/ossrh-parent.svg?color=green&label=maven%20central)](https://search.maven.org/search?q=g:tools.bestquality%20AND%20a:ossrh-parent)

# OSSRH Parent POM
An OSSRH parent POM file for deployment to Maven Central.

## Installation
```xml
<parent>
  <groupId>tools.bestquality</groupId>
  <artifactId>ossrh-parent</artifactId>
  <version>0.0.10</version>
</parent>
```
## Environment Variables
The following environment variables are expected to be available when deploying snapshot and release artifacts to
OSSRH:

| Name                           | Type     | Description                                                      |
|--------------------------------|----------|------------------------------------------------------------------|
| `CODE_SIGNING_KEY_FINGERPRINT` | `string` | The fingerprint of the GPG public key used to sign the artifacts |
| `CODE_SIGNING_KEY_PASSPHRASE`  | `string` | The passphrase associated with the code signing key              |

## OSSRH Deployment Properties
The following project properties should be overridden from an inheriting POM file in order to deploy snapshot and 
release artifacts to OSSRH:

| Name                    | Type     | Description                                                                              |
|-------------------------|----------|------------------------------------------------------------------------------------------|
| `ossrh.hostname`        | `string` | The hostname of your assigned Nexus Repository Manager instance, i.e. `oss.sonatype.org` |
| `ossrh.staging-profile` | `string` | The identifier of staging profile associated with your `group` coordinate                |

## Project Properties
The following project properties should be overridden from an inheriting POM file:

| Name              | Type     | Description                                                                                |
|-------------------|----------|--------------------------------------------------------------------------------------------|
| `repository.slug` | `string` | The slug of your GitHub repository in the following format: `<GH_USERNAME>/<GH_REPO_NAME>` |

repository.slug

## Maven Profiles

### `ossrh`
Activating the `ossrh` profile will skip the built-in `maven-deploy-plugin` plugin and engage the `maven-gpg-plugin` to
sign the project artifacts and the `nexus-staging-maven-plugin` to deploy the artifacts to OSSRH.