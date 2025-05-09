# Rack Installer Scripts
Scripts to easily install VCV Rack and its dependencies for a few different Linux distros.

The scripts check for dependencies; download and install them, if they are not present, and, finally, download and decompresses Rack to its default directory: "Rack2Free" in the user's home directory.

For example, if the current user is "myuser", Rack will be installed in 

```
/home/myuser/Rack2Free
```

The scripts do nothing fancy: they will not install graphical Jack connection managers or install and enable Pipewire Jack: those are exercises left to the user.

---

## Using the scripts

Get the installer script for your preferred distro, put it in your home directory and run it from the terminal command line.

| Script name             | Target Distribution | Package Manager |
| ----------------------- | ------------------- | --------------- |
| install_rack_manjaro.sh | Manjaro Linux       | pacman          |
| install_rack_ubuntu.sh  | Ubuntu              | apt             |
| install_rack_mint.sh    | Linux Mint          | apt             |
| install_rack_fedora.sh  | Fedora              | dnf             |

For example:

To use the Manjaro script, download it; put it in your home directory; open a terminal, and run:

```
./install_rack_manjaro.sh
```

Usage for other distros is similar: just pick the right script.

---

## Requirements

The scripts require:

- A reasonably recent version of your preferred distro.

- Bash.

- A user account capable of using sudo.

- A little comfort using the terminal.

---

# FAQ

## My favorite distro is not listed!

You can try using one of the available scripts that corresponds to the packaging system a particular distro uses, for example, the Ubuntu script might be compatible with Debian; check the table above to find out which package manager each script uses.

If none of the scripts work for your chosen distribution, contributions for new scripts are welcome!

---

## Help! I can't download the scripts!

You have a several options here.

Three common ones:

- Using your browser

  - Download the .zip or tar.gz file named "Source code" from the "Releases" page in this repository and decompress it. This will net you all the scripts, so just use the appropriate one.

  - You can download individual ones directly as well:

    - Click on the appropriate script for your distribution.

    - Click "Raw".

    - Save the script.
  
- Download it using wget or wget2:

  - Type
  
  ```
  wget https://raw.githubusercontent.com/Bloodbat/RackInstallerScripts/refs/heads/main/install_rack_<yourdistro>.sh
  ```

  - Substitute the \<yourdistro\> part for the distro you are using after consulting the the table above.

  - Press "Enter".

  - Make sure you set the script to be executable after downloading!

## How do I make a script executable?
## Help! I can't run the script!

- Run

  ```
  chmod +x <scriptname>.sh
  ```

  Where \<scriptname\> is your selected script.

## My distro is too old! The scripts are incompatible!

- Several options:

  - You could... update your distro.

  - You can also adjust the script.

    If you take this route, make sure you share it with us using a suitable name such as "install_rack_fedora_old.sh" or somesuch.