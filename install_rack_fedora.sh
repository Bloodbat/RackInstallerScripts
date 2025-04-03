#!/usr/bin/env bash

# Script version: 1.0

rackVersion=2.6.3
rackFolder=rack2
SUDO=''
originalFolder=$(pwd)

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
sudo dnf list --extras &> /dev/null

sudo dnf list installed wget2 &> /dev/null

if [ $? != 0 ]; then
  echo
  echo "Installing wget2..."
  sudo dnf install wget2

  if [ $? != 0 ]; then
    echo
    echo "Unable to install wget2"
    echo "Exiting now..."
    exit 1
  fi
fi

sudo dnf list installed unzip &> /dev/null

if [ $? != 0 ]; then
  echo
  echo "Installing unzip..."
  sudo dnf install unzip

  if [ $? != 0 ]; then
    echo
    echo "Unable to install unzip"
    echo "Exiting now..."
    exit 1
  fi
fi

sudo dnf list installed zenity &> /dev/null

if [ $? != 0 ]; then
  echo
  echo "Installing zenity..."
  sudo dnf install zenity

  if [ $? != 0 ]; then
    echo
    echo "Unable to install zenity"
    echo "Exiting now..."
    exit 1
  fi
fi

# Check for Jack-audio-connection-kit
sudo dnf list installed jack-audio-connection-kit &> /dev/null

if [ $? != 0 ]; then
  echo
  echo Installing jack-audio-connection-kit...
  sudo dnf install jack-audio-connection-kit

  if [ $? != 0 ]; then
    echo
    echo "Unable to install jack-audio-connection-kit"
    echo "Exiting now..."
    exit 1
  fi
fi

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
