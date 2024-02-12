#!/bin/sh

# shellcheck source=/dev/null

. ./setEnv.sh
. "${SUIF_CACHE_HOME}/01.scripts/commonFunctions.sh"
. "${SUIF_CACHE_HOME}/01.scripts/installation/setupFunctions.sh"

logI "Sourcing secure information..."
chmod u+x "${SDCCREDENTIALS_SECUREFILEPATH}"
. "${SDCCREDENTIALS_SECUREFILEPATH}"

logI "Installing Update Manager..."
mkdir -p "${SUIF_SUM_HOME}"
bootstrapSum "${SUIF_PATCH_SUM_BOOTSTRAP_BIN}" "" "${SUIF_SUM_HOME}"
