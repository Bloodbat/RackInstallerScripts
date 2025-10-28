#!/usr/bin/env bash

rackVersion=2.6.3
scriptVersion=3.1
SUDO=''
originalFolder=$(pwd)
wantJack=1
wantRackOnly=0

# Holds the selected distro:
#  0: no distro... leads to error and exit.
#  1: Manjaro.
#  2: Linux Mint and Ubuntu.
#  3: Fedora Linux.
# <--- Add new distros here! --->
selectedDistro=0
distroName=0

# Distro names for echo: update these as well when adding new distros.
distroLabels=("Manjaro Linux" "Linux Mint" "Ubuntu" "Fedora Linux")

# These setup the checker and installer commands for different distros;
# they are filled when a distro is selected.
checkCommand=''
installCommand=''

# Begin functions block.
function printErrorAndExit() {
  echo
  echo "Unable to install "$1"."
  echo
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
  echo "VCV Rack Free installer script Copyright (C) 2025"
  echo "Bloodbat / La Serpiente y la Rosa Producciones."
  echo "This program comes with ABSOLUTELY NO WARRANTY."
  echo "This is free software, and you are welcome to redistribute it."
  echo
  echo "Script version ${scriptVersion}"
  echo
}

function printHelp() {
  printHeader
  echo "Usage: $0 [-v <version> -j -d <distro> -r | -h]"
  echo -e "\t-v <version> Try to install specific Rack Free version."
  echo -e "\t-j           Skip JACK installation."
  echo -e "\t-d <distro>  Select Linux distribution from the command line."
  echo
  # Update these when new distros are added:
  echo -e "\t             Valid \"distro\" options are:"
  echo -e "\t             M Manjaro Linux\tT Linux Mint"
  echo -e "\t             U Ubuntu       \tF Fedora Linux"
  echo
  echo -e "\t-r           Install or update / downgrade Rack Free only."
  echo -e "\t-h           Show this help screen."
  echo
  echo "Options are Case Sensitive!"
  exit 2
}

function installRack() {
  echo "Getting VCV Rack Free ${rackVersion}..."
  wget https://vcvrack.com/downloads/RackFree-${rackVersion}-lin-x64.zip &> /dev/null

  if [ $? != 0 ]; then
   echo
   echo "Unable to get VCV Rack Free ${rackVersion}."
   echo
   echo "Exiting now..."
   exit 1
  fi

  echo "Unzipping VCV Rack Free ${rackVersion} to Rack2Free"
  unzip -q RackFree-${rackVersion}-lin-x64.zip

  if [ $? != 0 ]; then
   echo
   echo "Unable to decompress VCV Rack Free ${rackVersion}."
   echo
   echo "Cleaning up..."
   rm RackFree-${rackVersion}-lin-x64.zip
   echo "Exiting now..."
   exit 1
  fi

  echo "Cleaning up..."
  rm RackFree-${rackVersion}-lin-x64.zip
}

function installManjaroPrereqs() {
  checkCommand="pacman -Q"
  installCommand="pacman -S -q --noconfirm"

  checkAndInstall wget

  checkAndInstall unzip

  checkAndInstall zenity

  if [ $wantJack != 0 ]; then
    checkAndInstall jack2
  fi
}

function installUbuntuPrereqs() {
  checkCommand="dpkg -s"
  installCommand="apt -y install"

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
}

function installFedoraPrereqs() {
  checkCommand="dnf list installed"
  installCommand="dnf install"

  # Ensure we can list the packages: this system is not at all smart.
  $SUDO dnf list --extras &> /dev/null

  checkAndInstall wget2

  checkAndInstall unzip

  checkAndInstall zenity

  if [ $wantJack != 0 ]; then
    checkAndInstall jack-audio-connection-kit
  fi
}

function chooseDistro() {
  PS3='Please select your distribution: '
  distros=("Manjaro Linux" "Linux Mint" "Ubuntu" "Fedora Linux" "Quit")
  select distro in "${distros[@]}"
  do
    case $REPLY in
      1)
        selectedDistro=1
        distroName=0
        echo
        break
        ;;
      2)
        selectedDistro=2
        distroName=1
        echo
        break
        ;;
      3)
        selectedDistro=2
        distroName=2
        echo
        break
        ;;
      4)
        selectedDistro=3
        distroName=3
        echo
        break
        ;;
      5)
        echo
        echo "Aborted by user. Bye!"
        exit 0
        break
        ;;
      *) echo "Invalid option $REPLY";;
      esac
  done
}

function installPrereqs() {
  # We want to install in user's home folder.
  cd ~

  # Check if we're root.
  if [ $EUID != 0 ]; then
    SUDO='sudo'
  fi

  echo Installing initial prerequisites...

  case $selectedDistro in
    ## We are not supposed to be here...
    0)
      echo
      echo "Invalid distribution selection. Exiting now..."
      exit 1
      ;;
    1) installManjaroPrereqs;;
    2) installUbuntuPrereqs;;
    3) installFedoraPrereqs;;
    # <--- Add new distros here! --->
  esac
  echo
}
# End functions block.

# <--- Begin actual script --->
while getopts ':v:hjrd:' opt
do
  case $opt in
    v) rackVersion=$OPTARG;;
    d)
       # New distros need to be added here.
       case $OPTARG in
         M)
           selectedDistro=1
           distroName=0
           ;;
         U)
           selectedDistro=2
           distroName=2
           ;;
         T)
           selectedDistro=2
           distroName=1
         ;;
         F)
           selectedDistro=3
           distroName=3
           ;;
         *)
           echo "ERROR: Invalid distribution: \"$OPTARG\"."
           exit 1
           ;;
       esac
       ;;
    h) printHelp;;
    j) wantJack=0;;
    r) wantRackOnly=1;;
    \?)
      echo "ERROR: Invalid option: \"$OPTARG\"."
      echo
      echo "Type $0 -h for help."
      echo
      echo "Exiting now."
      exit 1
      ;;
  esac
done

printHeader

if [ $selectedDistro == 0 ]; then
  chooseDistro
fi

echo "Trying to install VCV Rack Free ${rackVersion} in ${distroLabels[distroName]}..."
echo

if [ $wantRackOnly == 0 ]; then
  installPrereqs
fi

installRack

echo
echo "Done! Enjoy your Rack Free!"
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

# Go back to wherever we started...
cd ${originalFolder}
# <--- End actual script --->