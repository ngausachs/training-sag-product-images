#!/bin/sh

# shellcheck source=/dev/null

. ./setEnv.sh
. "${SUIF_CACHE_HOME}/01.scripts/commonFunctions.sh"

logI "Updating OS software ..."
sudo apt-get -y update
logI "OS Software updated (sometimes forked background processes remain nonetheless)"

logI "Installing required libraries..."
# Sometimes apt-get remains running for some time after returning the control here. Going with retries...
maxRetries=5
crtRetry=0
lSuccess=1
while [ $lSuccess -ne 0 ]; do
  sudo apt-get -y install cifs-utils wget apt-transport-https software-properties-common
  lSuccess=$?
  if [ $lSuccess -eq 0 ]; then
    logI "Libraries installed successfully"
  else
    crtRetry=$((crtRetry+1))
    if [ $crtRetry -gt $maxRetries ]; then
      logE "Could not install the required libraries after the maximum number of retries!"
      exit 1
    fi
    logW "Installation of required libraries failed with code $lSuccess. Retrying $crtRetry/$maxRetries ..."
    sleep 10
  fi
done

. /etc/os-release
logI "Installing powershell, OS version is ${VERSION_ID} ..."
wget -q https://packages.microsoft.com/config/ubuntu/${VERSION_ID}/packages-microsoft-prod.deb
# Register the Microsoft repository GPG keys
sudo dpkg -i packages-microsoft-prod.deb
# Update the list of packages after we added packages.microsoft.com
sudo apt-get -y update

# Install PowerShell
crtRetry=0
lSuccess=1

while [ $lSuccess -ne 0 ]; do
  sudo apt-get -y install powershell
  lSuccess=$?
  if [ $lSuccess -eq 0 ]; then
    logI "Libraries installed successfully"
  else
    crtRetry=$((crtRetry+1))
    if [ $crtRetry -gt $maxRetries ]; then
      logE "Could not install powershell after the maximum number of retries!"
      exit 2
    fi
    logW "Installation of powershell failed with code $lSuccess. Retrying $crtRetry/$maxRetries "
    sleep 10
  fi
done

if [ ! "$(pwsh -version)" ] ; then
  logE "Powershell is not available! Cannot continue"
  exit 3
fi

logI "Machine prepared successfully"
