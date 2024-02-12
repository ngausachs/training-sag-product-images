#!/bin/bash

# shellcheck source=/dev/null

. ./setEnv.sh
. "${SUIF_CACHE_HOME}/01.scripts/commonFunctions.sh"
. "${SUIF_CACHE_HOME}/01.scripts/installation/setupFunctions.sh"

logI "Sourcing secure information..."
chmod u+x "${SDCCREDENTIALS_SECUREFILEPATH}"
. "${SDCCREDENTIALS_SECUREFILEPATH}"

# Check if credentials are valid
checkEmpowerCredentials || exit $?
