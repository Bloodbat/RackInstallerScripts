# Rack Free Installer Script

### Script version 4.0

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

The script will ask you for the distribution you are using interactively; just type the number (or the Quit option to abort) and press the ENTER key.

The script is written for and has been tested with the following distributions:

| Distribution  | Package Manager |
| ------------- | --------------- |
| Manjaro Linux | pacman          |
| Arch Linux    | pacman          |
| EndeavourOS   | pacman          |
| Linux Mint    | apt             |
| Ubuntu        | apt             |
| Debian        | apt             |
| Pop!_OS       | apt             |
| Fedora Linux  | dnf             |

The script may work for other distributions using the same package manager.

Distributions can also be selected using the command line by passing it the -d option followed by the UPPERCASE letter set for a known distribution; for example to install Rack Free in Ubuntu directly, run:

```
install_rack_free.sh -d D
```

Known distributions and their set letters are the following:

| Distribution      | Base         | Command line option |
| ----------------- | ------------ | ------------------- |
| **Manjaro Linux** | Arch Linux   | A                   |
| **Arch Linux**    | Arch Linux   | A                   |
| **EndeavourOS**   | Arch Linux   | A                   |
| **Linux Mint**    | Debian       | D                   |
| **Ubuntu**        | Debian       | D                   |
| **Debian**        | Debian       | D                   |
| **Pop!_OS**       | Debian       | D                   |
| **Fedora Linux**  | Fedora Linux | F                   |

The script includes a help screen; to display it, run:

```
install_rack_free.sh -h
```

Installation of JACK can be skipped so the script is useful for more, untested, distributions and to avoid overwriting existing installations if they are not detected by it, run:

```
install_rack_free.sh -j
```

Specific Rack Free versions can be installed using the -v option; for example to install the old Rack Free 2.5.2 version, run:

```
install_rack_free.sh -v 2.5.2
```

If you just to download and decompress the default Rack Free version set by the script, ignoring the prerequisites, run:

```
install_rack_free.sh -r
```

The script can also update or downgrade existing Rack Free installations to a different version; for example to update Rack Free 2.6.3, the default installed by this script, to Rack Free 2.6.5, run:

```
install_rack_free.sh -u 2.6.5
```

The `-v` and `-u` options are mutually exclusive: if both are used, an error will be printed and the script will exit.

**Keep in mind!** Command line options are *case sensitive* and option order is not relevant.

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

You can try selecting an existing distribution that uses the same packaging system and manager your particular distro uses; for example, selecting Arch Linux might work with Garuda Linux; check the table above to find out which package manager the script acknowledges for each distribution.

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

  - Press ENTER.

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

That said... if you want a different version, just pass it using the `-v` parameter.

For example, to install VCV Rack Free version 2.6.4, type:

```
install_rack_free.sh -v 2.6.4
```

and press ENTER.

The script *does not* check for version correctness before trying to download a VCV Rack Free distribution: it will fail if the selected version is not found.

## Can I use the script to update Rack Free to the latest version?

Yes! Just pass it using the `-u` option.

For example, to update Rack Free 2.6.3 to Rack Free 2.6.5, type:

```
install_rack_free.sh -u 2.6.5
```

## My distro is too old! The script is incompatible!

- Several options:

  - You could... update your distro.

  - You can also adjust the script, it is written to be clear and user friendly.

    If you take this route, please, make sure you share your changes with us!