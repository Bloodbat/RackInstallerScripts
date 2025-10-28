# Rack Free Installer Script
A script to easily install VCV Rack Free and its dependencies for a few different Linux distros.

The script checks for dependencies; downloads and installs them, if they are not present, and, finally, downloads and decompresses Rack Free to its default directory: "Rack2Free" in the user's home directory.

For example, if the current user is "myuser", Rack Free will be installed in

```
/home/myuser/Rack2Free
```

The script does nothing fancy: it will not install graphical Jack connection managers or install and enable Pipewire Jack: those are exercises left to the user.

## The script installs VCV Rack Free version 2.6.3 by default.

### The script does not and cannot install the paid version of VCV Rack! If you need help installing that version, contact VCV Rack support!

---

## Using the script

Get the installer script; put it in your home directory, and run it from the terminal command line.

The script will ask you for the distribution you are using interactively; just type the number (or the Quit option to abort) and press the Enter key.

The script is written to be compatible with the following distributions; but it may work for others using the same package manager:

| Distribution  | Package Manager |
| ------------- | --------------- |
| Manjaro Linux | pacman          |
| Ubuntu        | apt             |
| Linux Mint    | apt             |
| Fedora Linux  | dnf             |

Distributions can also be selected using the command line by passing it the -d option followed by the UPPERCASE letter set for a known distribution; for example to install Rack Free in Ubuntu directly, run:

```
install_rack_free.sh -d U
```

Known distributions and their set letters are the following:

| Distribution  | Command line option |
| ------------- | ------------------- |
| Manjaro Linux | M                   |
| Ubuntu        | U                   |
| Linux Mint    | T                   |
| Fedora Linux  | F                   |

The script includes a help screen; to display it, run:

```
install_rack_free.sh -h
```

Installation of JACK can be skipped so that the script is more useful to more distributions and to avoid overwriting existing installations, run:

```
install_rack_free.sh -j
```

Specific Rack Free versions can be installed using the -v option; for example to install the old Rack Free 2.5.2 version, run:

```
install_rack_free.sh -v 2.5.2
```

Keep in mind command line options are *case sensitive*.

---

## Requirements

The script requires:

- A reasonably recent version of your preferred distro.

- Bash.

- A user account capable of using sudo.

- A little comfort using the terminal.

---

# FAQ

## My favorite distro is not listed!

You can try selecting an existing distribution that uses the same packaging system and manager your particular distro uses; for example, selecting Ubuntu might work with Debian; check the table above to find out which package manager the script acknowledges for each distribution.

If none of the options work for your chosen distribution, contributions for new distributions are welcome!

---

## Help! I can't download the script!

You have a several options here.

Three common ones:

- Using your browser

  - Download the .zip or tar.gz file named "Source code" from the "Releases" page in this repository and decompress it.

  - You can download the script directly as well using your browser as well:

    - Click on the script.

    - Click "Raw".

    - Save the script.

- Download it using wget or wget2:

  - Type

  ```
  wget https://raw.githubusercontent.com/Bloodbat/RackInstallerScripts/refs/heads/main/install_rack_free.sh
  ```

  - Press "Enter".

  - Make sure you set the script to be executable after downloading!

## How do I make a script executable?
## Help! I can't run the script!

- Run

  ```
  chmod +x install_rack_free.sh
  ```

## The default version of VCV Rack Free installed by the script is too old / too new!

The default version is selected using the wisdom of the community in the forum and our personal experience.

Versions passing both tests will be the default whenever the script is updated.

That said... if you want a different version, just pass it using the "-v" parameter sans the quotes.

For example, to install VCV Rack Free version 2.6.4, type:

```
install_rack_free.sh -v 2.6.4
```

and press ENTER.

The script *does not* check for version correctness before trying to download a VCV Rack Free distribution, so... make sure you type an available version.

## My distro is too old! The script is incompatible!

- Several options:

  - You could... update your distro.

  - You can also adjust the script, it is written to be clear and user friendly.

    If you take this route, please, make sure you share your changes with us!