#!/usr/bin/env bash

# Script version: 2.0

rackVersion=2.6.3
SUDO=''
originalFolder=$(pwd)

# These setup the checker and installer commands for different distros.
checkCommand="dnf list installed"
installCommand="dnf install"

function printErrorAndExit() {
  echo
  echo "Unable to install "$1""
  echo "Exiting now..."
  exit 1
}

function checkAndInstall() {
  ${checkCommand} "$1" &> /dev/null

  if [ $? != 0 ]; then
    echo
    echo "Installing "$1"..."
    $SUDO ${installCommand} "$1"

    if [ $? != 0 ]; then
      printErrorAndExit "$1"
    fi
  fi
}

echo "VCV Rack ${rackVersion} installer for Fedora Copyright (C) 2025"
echo "Bloodbat / La Serpiente y la Rosa Producciones."
echo "This program comes with ABSOLUTELY NO WARRANTY."
echo "This is free software, and you are welcome to redistribute it."
echo

cd ~

# Check if we're root.
if [ $EUID != 0 ]; then
  SUDO='sudo'
fi

echo Installing initial prerequisites...

# Ensure we can list the packages: this system is not at all smart.
$SUDO dnf list --extras &> /dev/null

checkAndInstall wget2

checkAndInstall unzip

checkAndInstall zenity

checkAndInstall jack-audio-connection-kit

echo "Getting VCV Rack ${rackVersion}..."
wget2 https://vcvrack.com/downloads/RackFree-${rackVersion}-lin-x64.zip &> /dev/null

if [ $? != 0 ]; then
 echo
 echo "Unable to get VCV Rack ${rackVersion}"
 echo "Exiting now..."
 exit 1
fi

echo "Unzipping VCV Rack ${rackVersion} to Rack2Free"
unzip -q RackFree-${rackVersion}-lin-x64.zip

if [ $? != 0 ]; then
 echo
 echo "Unable to decompress VCV Rack ${rackVersion}"
 echo "Exiting now..."
 exit 1
fi

echo "Cleaning up..."
rm RackFree-${rackVersion}-lin-x64.zip

echo
echo "Done! Enjoy your Rack!"
echo
echo "You can run VCV Rack ${rackVersion} from the command line by typing:"
echo "'cd ${HOME}/Rack2Free' Enter"
echo "'./Rack' Enter"
echo
echo "Bye now!"
cd ${originalFolder}
