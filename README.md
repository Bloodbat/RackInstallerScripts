# Rack Installer Scripts
Installer scripts to easily install VCV Rack and its dependencies for different Linux distros.

The script checks for dependencies; downloads and installs them, if they are not present, and, finally, downloads and decompresses Rack to its default directory: "Rack2Free" in the user's home directory.

For example, if the current user is "myuser", Rack will be installed in 

```
/home/myuser/Rack2Free
```

The scripts do nothing fancy: they will not install graphical Jack connection managers or install and enable Pipewire Jack: those are exercises left to the user.

---

## Using the scripts

Get the installer script for your preferred distro, put it in your home directory and run it from the terminal command line.

| Script name             | Target Distribution |
| ----------------------- | ------------------- |
| install_rack_manjaro.sh | Manjaro Linux       |
| install_rack_ubuntu.sh  | Ubuntu              |
| install_rack_mint.sh    | Linux Mint          |
| install_rack_fedora.sh  | Fedora              |

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

---

## My favorite distro is not listed!

You can try using one of the available scripts that corresponds to the packaging system a particular distro uses, for example, the Ubuntu script might be compatible with Debian.

If it doesn't work, contributions for new distro scripts are welcome!

---

## Help! I can't download the scripts!

You have a several options here.

Two common ones:

- Using your browser

  - Click on the appropriate script for your distribution.

  - Click "Raw".

  - Save the script.
  
- Download it using wget or wget2:

  - Type
  
    ```
    wget https://raw.githubusercontent.com/Bloodbat/RackInstallerScripts/refs/heads/main/install_rack_<yourdistro>.sh
    ```

    Substitute \<yourdistro\> using the table above.

    then press "Enter".

    Make sure you set the script to be executable after downloading!

## How do I make the script executable?
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

    Make sure you share it with us using a suitable name such as "install_rack_fedora_old.sh" or somesuch.