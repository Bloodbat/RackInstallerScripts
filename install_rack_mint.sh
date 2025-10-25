#!/usr/bin/env bash

rackVersion=2.6.3
scriptVersion=2.3
SUDO=''
originalFolder=$(pwd)
wantJack=1

# These setup the checker and installer commands for different distros.
checkCommand="dpkg -s"
installCommand="apt -y install"

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

function printHeader() {
  echo "VCV Rack Free installer for Manjaro Copyright (C) 2025"
  echo "Bloodbat / La Serpiente y la Rosa Producciones."
  echo "This program comes with ABSOLUTELY NO WARRANTY."
  echo "This is free software, and you are welcome to redistribute it."
  echo
  echo "Script version ${scriptVersion}"
  echo
}

function printHelp() {
  printHeader
  echo "Usage: $0 [-v <version> | -h]"
  echo -e "\t-v <version> Try to install specific Rack free version."
  echo -e "\t-h           Show this help screen."
  echo -e "\t-j           Skip installation of JACK."
  echo
  exit 2
}

while getopts ':v:hj' opt
do
  case $opt in
    v) rackVersion=$OPTARG;;
    h) printHelp;;
    j) wantJack=0;;
    \?) echo "ERROR: Invalid option"
    exit 1;;
  esac
done

printHeader
echo "Trying to install VCV Rack Free ${rackVersion}..."
echo

cd ~

# Check if we're root.
if [ $EUID != 0 ]; then
  SUDO='sudo'
fi

echo Installing initial prerequisites...

checkAndInstall wget

checkAndInstall unzip

checkAndInstall zenity

# Don't overwrite jack in certain Ubuntu versions.
${checkCommand} libjack-jackd2-0 &> /dev/null
if [ $? != 0 ]; then
  if [ $wantJack != 0 ]; then
    checkAndInstall libjack0
  fi
fi

echo "Getting VCV Rack Free ${rackVersion}..."
wget https://vcvrack.com/downloads/RackFree-${rackVersion}-lin-x64.zip &> /dev/null

if [ $? != 0 ]; then
 echo
 echo "Unable to get VCV Rack Free ${rackVersion}"
 echo "Exiting now..."
 exit 1
fi

echo "Unzipping VCV Rack Free ${rackVersion} to Rack2Free"
unzip -q RackFree-${rackVersion}-lin-x64.zip

if [ $? != 0 ]; then
 echo
 echo "Unable to decompress VCV Rack Free ${rackVersion}"
 echo "Exiting now..."
 exit 1
fi

echo "Cleaning up..."
rm RackFree-${rackVersion}-lin-x64.zip

echo
echo "Done! Enjoy your Rack!"
echo
echo "You can run VCV Rack Free ${rackVersion} from the command line by typing:"
echo "'cd ${HOME}/Rack2Free' Enter"
echo "'./Rack' Enter"
echo
echo "Now that VCV Rack Free is installed; perhaps you would enjoy my plugins!"
echo "They are free as in freedom and as in beer!"
echo "You can get them from the VCV Rack Library:"
echo "Sanguine Mutants:"
echo "https://library.vcvrack.com/SanguineMutants"
echo "Sanguine Monsters:"
echo "https://library.vcvrack.com/SanguineMonsters"
echo
echo "Bye now!"
cd ${originalFolder}
