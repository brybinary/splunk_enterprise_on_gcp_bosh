#!/usr/bin/env bash

set -e

REPO_DIR="$( cd "$1" && pwd )"
TILE_DIR="$( cd "$2" && pwd )"
POOL_DIR="$( cd "$3" && pwd )"
MISSING_PROPERTIES_DIR="$( cd "$4" && pwd )"

TILE_FILE=`cd "${TILE_DIR}"; ls *.pivotal`
if [ -z "${TILE_FILE}" ]; then
	echo "No files matching ${TILE_DIR}/*.pivotal"
	ls -lR "${TILE_DIR}"
	exit 1
fi

PRODUCT=`echo "${TILE_FILE}" | sed "s/-[^-]*$//"`
VERSION=`echo "${TILE_FILE}" | sed "s/.*-//" | sed "s/\.pivotal\$//"`

cd "${POOL_DIR}"

echo "Available products:"
pcf products
echo

echo "Uploading ${TILE_FILE}"
pcf import "${TILE_DIR}/${TILE_FILE}"
echo

echo "Available products:"
pcf products
pcf is-available "${PRODUCT}" "${VERSION}"
echo

echo "Installing product ${PRODUCT} version ${VERSION}"
pcf install "${PRODUCT}" "${VERSION}"
echo

echo "Available products:"
pcf products
pcf is-installed "${PRODUCT}" "${VERSION}"
echo

echo "Current missing properties don't work for integration test... just enough to get tile to install"
echo ""

echo "Configuring product ${PRODUCT}"
pcf configure --skip-validation "${PRODUCT}" "${MISSING_PROPERTIES_DIR}/splunk-missing-properties.yml"
echo

echo "Applying Changes"
pcf apply-changes --deploy-errands=deploy-all
echo
