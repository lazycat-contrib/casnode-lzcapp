#!/bin/sh
# Check out the upstream release the embed images are built from.
#
# The Docker Hub image for this project only carries the legacy v1.x
# architecture (MySQL + Casdoor SSO, no local sign-in). The current v2.x line
# ships local accounts on SQLite but publishes no image, so this package builds
# v2.x from source and embeds the result.
set -eu

VERSION="${CASNODE_VERSION:-v2.1.0}"

echo "casnode: fetching ${VERSION}"
rm -rf upstream
mkdir -p upstream

TARBALL="https://codeload.github.com/casnode/casnode/tar.gz/${VERSION}"
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "${TARBALL}" | tar -xz -C upstream --strip-components=1
else
  wget -qO- "${TARBALL}" | tar -xz -C upstream --strip-components=1
fi

# Fail loudly rather than producing an empty image from a silent 404.
test -f upstream/Dockerfile
test -f upstream/web/package.json
test -f upstream/web/yarn.lock
test -f upstream/go.mod

echo "casnode: source ready at ./upstream"
