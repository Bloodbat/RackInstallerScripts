#!/usr/bin/env bash

rackVersion=2.6.3
scriptVersion=4.1
SUDO=''
wantJack=1
wantRackOnly=0
lastCheck=0
wantVersion=0

# Holds the selected distro:
# 0: no distro... leads to error and exit.
# 1: updating only... THIS MUST BE KEPT HERE!
# 2: Arch based (Manjaro Linux, Arch Linux, EndeavourOS).
# 3: Debian based (Linux Mint, Ubuntu, Debian, Pop!_OS, Devuan).
# 4: Fedora Linux based.
# 5: Suse based (OpenSUSE Leap, OpenSUSE Tumbleweed).
# 6: OpenMandriva based (OpenMandriva Rome)
# TODO: <--- Add new distro numbers here! --->
selectedDistro=0
distroName=0

# TODO: Distro names for echo: update these when adding new distros!
distroLabels=("Arch Linux" "Debian" "Fedora Linux", "Suse", "OpenMandriva")

# These setup the checker and installer commands for different distros;
# they are filled when a distro is selected.
checkCommand=''
installCommand=''
packageManager=''

# Begin functions block.
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

function checkForPackage() {
  echo
  echo "Checking if $1 is installed..."
  ${checkCommand} "$1" &> /dev/null
  lastCheck=$?
  if [ $lastCheck == 0 ]; then
    echo ""$1" is already installed."
  fi
}

function checkAndInstall() {
  checkForPackage "$1"

  if [ $lastCheck != 0 ]; then
    install "$1"
  fi
}

function install() {
    echo
    echo "Installing "$1"..."
    $SUDO ${installCommand} "$1"

    if [ $? != 0 ]; then
      printErrorAndExit "$1"
    fi
}

function installPrereqs() {
  # We want to install in the user's home folder.
  cd ~

  # Check if we're root.
  if [ $EUID != 0 ]; then
    SUDO='sudo'
  fi

  echo Installing initial prerequisites...

  case $selectedDistro in
    # We are not supposed to be here...
    0)
      echo
      echo "Invalid distribution selection. Exiting now..."
      exit 1
      ;;
    1) ;; # This is for updating! Do not remove!
    2) installArchPrereqs;;
    3) installDebianPrereqs;;
    4) installFedoraPrereqs;;
    5) installSusePrereqs;;
    6) installMandrivaPrereqs;;
    # TODO: <--- Add new distros here! --->
  esac
  echo
}

function checkPackageManager() {
  echo
  echo "Checking for package manager $packageManager..."
  command -v $packageManager &> /dev/null
  if [ $? != 0 ]; then
    echo
    echo "ERROR: package manager $packageManager not found."
    echo "Exiting now..."
    exit 1
  fi
  echo "Package manager found."
}

function installArchPrereqs() {
  packageManager="pacman"

  checkPackageManager

  checkCommand="$packageManager -Q"
  installCommand="$packageManager -S -q --noconfirm"

  checkAndInstall wget

  checkAndInstall unzip

  checkAndInstall zenity

  if [ $wantJack != 0 ]; then
    # Don't try to clobber pipewire-jack...
    checkForPackage pipewire-jack
    if [ $lastCheck != 0 ]; then
      checkAndInstall jack2
    fi
  fi
}

function installDebianPrereqs() {
  packageManager="dpkg"

  checkPackageManager

  packageManager="apt"

  checkPackageManager

  checkCommand="dpkg -s"
  installCommand="apt -y install"

  checkAndInstall wget

  checkAndInstall unzip

  checkAndInstall zenity

  if [ $wantJack != 0 ]; then
    # Don't overwrite jack in certain Ubuntu versions.
    checkForPackage libjack-jackd2-0
    if [ $lastCheck != 0 ]; then
      checkAndInstall libjack0
    fi
  fi
}

function installFedoraPrereqs() {
  packageManager="dnf"

  checkPackageManager

  checkCommand="$packageManager list installed"
  installCommand="$packageManager -y install"

  # Ensure we can list the packages: this system is not at all smart.
  $SUDO $packageManager list --extras &> /dev/null

  checkAndInstall wget2

  checkAndInstall unzip

  checkAndInstall zenity

  if [ $wantJack != 0 ]; then
    checkAndInstall jack-audio-connection-kit
  fi
}

function installSusePrereqs() {
  packageManager="zypper"

  checkPackageManager

  checkCommand="$packageManager search -i"
  installCommand="$packageManager --non-interactive install"

  checkAndInstall wget

  checkAndInstall unzip

  checkAndInstall zenity

  if [ $wantJack != 0 ]; then
    checkAndInstall pipewire-jack
  fi
}

function installMandrivaPrereqs() {
  packageManager="dnf"

  checkPackageManager

  checkCommand="$packageManager list installed"
  installCommand="$packageManager -y install"

  # Ensure we can list the packages: this system is not at all smart.
  $SUDO $packageManager list --extras &> /dev/null

  checkAndInstall wget

  checkAndInstall unzip

  checkAndInstall zenity

  if [ $wantJack != 0 ]; then
    checkAndInstall lib64jack0
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
  echo "Usage: $0 [(-v <version> | -u <version>) -j -d <distro> -r | -h]"
  echo -e "\t-v <version> Try to install specific Rack Free version."
  echo -e "\t-j           Skip JACK installation."
  echo -e "\t-u <version> Update or downgrade Rack Free to the specified version."
  echo -e "\t-d <distro>  Select Linux distribution from the command line."
  echo
  echo -e "\t             Valid \"distro\" options are:"
  # TODO: Update these when new distros are added!
  echo -e "\t             A Arch Linux based (Manjaro Linux, Arch Linux, EndeavourOS)"
  echo -e "\t             D Debian based (Linux Mint, Ubuntu, Debian, Pop!_OS, Devuan)"
  echo -e "\t             F Fedora Linux based"
  echo -e "\t             S Suse based (OpenSUSE Leap, OpenSuse Tumbleweed)"
  echo -e "\t             O OpenMandriva based (OpenMandriva Rome)"
  echo
  echo -e "\t-r           Install or update / downgrade Rack Free only."
  echo -e "\t-h           Show this help screen."
  echo
  echo "Options are Case Sensitive!"
  exit 2
}

function printErrorAndExit() {
  echo
  echo "ERROR: Unable to install "$1"."
  echo
  echo "Exiting now..."
  exit 1
}

function chooseDistro() {
  # TODO: This prompt needs updating when adding new distributions!
  PS3='Type the number of your distribution and press ENTER [1-5] '
  # TODO: Update this array when adding new distributions! Quit should ALWAYS be last!
  distros=("Arch Linux based (Manjaro Linux, Arch Linux, EndeavourOS)" "Debian based (Linux Mint, Ubuntu, Debian, Pop!_OS, Devuan)" "Fedora Linux based (Fedora Linux)" "Suse based (OpenSUSE Leap, OpenSuse Tumbleweed)" "OpenMandriva based (OpenMandriva Rome)" "Quit")
  select distro in "${distros[@]}"
  do
    case $REPLY in
      1)
        selectedDistro=2
        distroName=0
        echo
        break
        ;;
      2)
        selectedDistro=3
        distroName=1
        echo
        break
        ;;
      3)
        selectedDistro=4
        distroName=2
        echo
        break
        ;;
      4)
        selectedDistro=5
        distroName=3
        echo
        break
        ;;
      5)
        selectedDistro=6
        distroName=4
        echo
        break
        ;;
      6)
        echo
        echo "Aborted by user. Bye!"
        exit 0
        break
        ;;
      *) echo "Invalid option $REPLY";;
      esac
  done
}
# End functions block.

# <--- Begin actual script --->
while getopts ':v:hjrd:u:' opt
do
  case $opt in
    v)
     rackVersion=$OPTARG
     wantVersion=1
     ;;
    d)
       # TODO: Update this logic when new distros are added.
       case $OPTARG in
         A)
           selectedDistro=2
           distroName=0
           ;;
         D)
           selectedDistro=3
           distroName=1
           ;;
         F)
           selectedDistro=4
           distroName=2
           ;;
         S)
           selectedDistro=5
           distroName=3
           ;;
         O)
           selectedDistro=6
           distroName=4
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
    u)
      selectedDistro=1
      rackVersion=$OPTARG
      wantRackOnly=1
      ;;
    \?)
      echo "ERROR: Invalid option: \"$OPTARG\"."
      echo
      echo "Type $0 -h for help."
      echo
      echo "Exiting now."
      exit 1
      ;;
    :)
      echo "ERROR: Option -$OPTARG requires an argument."
      echo
      echo "Type $0 -h for help."
      echo
      echo "Exiting now..."
      exit 1
      ;;
  esac
done

printHeader

if [ $selectedDistro == 0 ]; then
  chooseDistro
fi

if [ $selectedDistro != 1 ]; then
  echo "Trying to install VCV Rack Free ${rackVersion} for ${distroLabels[distroName]} based distribution..."
  echo
else
  if [ $wantVersion == 1 ]; then
    echo "ERROR: -u and -v are mutually exclusive!"
    echo "Exiting now..."
    exit 1
  fi
  echo "Trying to update VCV Rack free to ${rackVersion}..."
fi

if [ $wantRackOnly == 0 ]; then
  installPrereqs
fi

installRack

echo
echo "Done! Enjoy your Rack Free!"
echo
echo "You can run VCV Rack Free ${rackVersion} from the command line by typing:"
echo
echo "'cd $HOME/Rack2Free' and pressing ENTER."
echo
echo "Followed by"
echo
echo "'./Rack' and pressing ENTER."
echo
echo "Now that VCV Rack Free is installed; perhaps you would enjoy my plugins!"
echo
echo "They are free as in freedom and as in beer!"
echo
echo "You can get them from the VCV Rack Library:"
echo "Sanguine Mutants:"
echo "https://library.vcvrack.com/SanguineMutants"
echo
echo "Sanguine Monsters:"
echo "https://library.vcvrack.com/SanguineMonsters"
echo
echo "Bye now!"
# <--- End actual script --->
