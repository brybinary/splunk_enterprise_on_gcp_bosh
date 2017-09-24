#!/usr/bin/env bash

set -e

POOL_DIR="$( cd "$1" && pwd )"
PRODUCT="splunk-firehose-nozzle"

BIN_DIR="$( cd "${TILE_GEN_DIR}/bin" && pwd )"

cd "${POOL_DIR}"

echo "Available products:"
pcf products
echo

if ! pcf is-installed "${PRODUCT}" ; then
	echo "${PRODUCT} not installed - skipping removal"
	exit 0
fi

echo "Uninstalling ${PRODUCT}"
pcf uninstall "${PRODUCT}"
echo

echo "Applying Changes"
pcf apply-changes
echo

echo "Available products:"
pcf products
echo

if pcf is-installed "${PRODUCT}" ; then
	echo "${PRODUCT} remains installed - remove failed"
	exit 1
fi
