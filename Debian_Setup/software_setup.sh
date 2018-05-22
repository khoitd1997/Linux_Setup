#!/bin/bash
# scripts written for setting up a fresh Debian based system

#----------------------------------------------------------------------------------------------------
# Variables start here
# Modify software lists here
# NO SPACE AROUND '=' for variable assignment

# list of general utilities without GUI

software_general_repo_non_gui=" doxygen checkinstall lm-sensors cmake valgrind \
gcc clang llvm emacs build-essential htop net-tools  minicom screen python3-pip curl python-pip \
"

# list of software with GUI
software_with_gui=" xclip terminator guake ddd evince synaptic psensor gufw xpad \
libreoffice-style-hicontrast unattended-upgrades gparted \
libappindicator1 libindicator7 hardinfo chromium-browser moserial libncurses* nautilus-dropbox meld \
bustle d-feet graphviz virtualbox npm shellcheck "

# list of dropped app
software_dropped=" gitg"

# all tool chains and utilities
tool_chain_not_18_04_compat=" gdb-arm-none-eabi " # not compatible with ubuntu 18.04 for now
arm_toolchain=" openocd qemu gcc-arm-none-eabi"
avr_arduino_toolchain="avrdude avr-libc simulavr"

# snap package list
snap_package_list_general="spotify discord gitkraken atom vscode slack "
# pending list waiting approval list
snap_package_list_pending=" "
# include heavy stuffs like IDE
snap_package_list_extended=" intellij-idea-community android-studio "

# python pip list
python_pip_package_list=" pylint autopep8 "

source ../utils.sh
# Configuration Parameters
wsl=1 # 0 for installing on Window Subsystem for Linux, 1 for not wsl by default
set -e 
set -o pipefail
set -o nounset

#----------------------------------------------------------------------------------------------------
check_dir OS_Setup/Debian_Setup

# disable root account
sudo passwd -l root

printf "\n ${cyan} ---------BASIC-----------\n ${reset}"
print_message "Starting $(basename $0)\n " # extract base name from $0
cd # back to home directory

if [ $wsl -eq 1 ] ; then
if sudo ufw enable; then
print_message "Firewall Enabled\n"
else
print_error "Firewall failed to enable\n "
exit 1
fi
fi

#----------------------------------------------------------------------------------------------------
# software installation here
# update the system, only proceed if the previous command is successful
if [ $wsl -eq 1 ] ; then
    SOFTWARE_GENERAL_REPO="${software_general_repo_non_gui}${software_with_gui}"
else
    SOFTWARE_GENERAL_REPO="${software_general_repo_non_gui}"
fi

if sudo apt-get update\
&& sudo apt-get dist-upgrade\
&& sudo apt-get install ${SOFTWARE_GENERAL_REPO}
then
print_error "Basic Setup Done\n "
else
print_error "Failed in Basic update and install\n "
exit 1
fi

# use snap package here
# Note: snap provides the same level of security as app due to X11
sudo apt-get install snapd -y

for snap_package_general in ${snap_package_list_general} ; do
	sudo snap install ${snap_package_general} --classic
done

for snap_package in ${snap_package_list_extended} ; do 
    print_message "Do you want to install ${snap_package} (y/n)"
    empty_input_buffer
    read snap_package_answer
    if [ ${snap_package_answer} = "y" ]; then
    sudo snap install ${snap_package} --classic
    fi
done

sudo dpkg-reconfigure unattended-upgrades

# Added access to usb ports for current user
sudo usermod -a -G dialout ${USER}

# setup GNOME keyring git credential helper
sudo apt-get install libgnome-keyring-dev
sudo make --directory=/usr/share/doc/git/contrib/credential/gnome-keyring/
git config --global credential.helper /usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring
git config --global user.email "khoidinhtrinh@gmail.com"
git config --global user.name "khoitd1997"

# sound config
clear
print_message "Configuring Sound\n"

# this used amixer to disable auto mute for card number 1, auto-mute basically allows only either the speaker
# or the headphone at the same time so disabling it allows both to be on
# the card number may change but always pick the realtek/analog one, generally use alsamixer or 
# aplay -l to find card number to find the correct card number
aplay -l # list available playback device
print_message "Please input the correct card number from above, it should be the analog one(probably not the nvidia one)"
empty_input_buffer
read sound_card_number
amixer -c ${sound_card_number} set 'Auto-Mute Mode' 'Disabled'

#----------------------------------------------------------------------------------------------------

# Dev tools installations start here
printf "\n ${cyan}--------DEV-TOOLS----------- ${reset}"
printf "${cyan}\n Basic Install is done, please select additional install options separated by space: \n${reset}"
printf  "${cyan}1/ARM 2/AVR 3/Java 4/Python${reset}"
read software_option

# handle options
for option in ${software_option}; do
case $option in 
    1) 
    print_message "Installing ARM\n"
    if ! sudo apt-get install $arm_toolchain; then
    print_error "Failed to install ARM toolchain\n"
    exit 1
    fi ;;
    2) 
    print_message "Installing AVR\n "
    if ! sudo apt-get install $avr_arduino_toolchain; then
    print_error "Failed to install AVR toolchain\n"
    exit 1
    fi ;;
    3) 
    print_message "Installing java 8, gradle, check PPA and newer version of Java, press anykey to confirm\n"
    read confirm
    print_message "Please press any key again for final confirm\n"
    read confirm
    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get update 
    sudo apt-get install gradle -y 
    sudo apt-get install oracle-java8-installer -y ;;
    4)
    print_message "Installing Python support"
for pip_software in ${python_pip_package_list}; do
    pip install ${pip_software}
done
    ;;
esac
done 
sudo apt autoremove -y

#----------------------------------------------------------------------------------------------------
# Post installtion messages start here
exit 0
