#!/bin/bash
# scripts written for setting up a fresh RPM based system

#----------------------------------------------------------------------------------------------------
# Variables start here
# Modify software lists here

# fedora software group
software_group=" @development-tools "

software_dropped_not_in_repo=" checkinstall build-essential gufw hardinfo "

# list of general utilities without GUI
software_general_repo_non_gui=" doxygen lm-sensors cmake valgrind \
gcc clang llvm emacs htop net-tools minicom screen python3-pip sqlite nano python3 "

# list of software with GUI
software_with_gui=" gksu terminator guake ddd evince synaptic psensor xpad \
unity-tweak-tool libreoffice-style-hicontrast unattended-upgrades gparted \
libappindicator1 libindicator7 i-nex moserial libncurses* python-gpgme "

# list of dropped app
software_dropped=" gitg"

software_non_fedora_repo=" lpf-spotify-client "

# all tool chains and utilities
arm_toolchain="gdb-arm-none-eabi openocd qemu gcc-arm-none-eabi"
avr_arduino_toolchain="avrdude avr-libc simulavr"

source ../utils.sh
set -e 
set -o pipefail
set -o nounset
#----------------------------------------------------------------------------------------------------
print_message "Starting Installation of Fedora Machine"
sudo systemctl status firewalld

sudo dnf install ${software_group}

# install rpm fusion
print_message "Please insert rpm free and non-free repo link separated by space"
read rpm_link
for link in ${rpm_link}; do
sudo dnf install ${link}
done

sudo dnf update 


