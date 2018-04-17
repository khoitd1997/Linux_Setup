#!/bin/bash
# scripts written for setting up a fresh Debian based system
# chmod u+x setup.sh will make the file executable for only owner

#----------------------------------------------------------------------------------------------------
# Variables start here
# Modify software lists here
# NO SPACE AROUND '=' for variable assignment

# list of general utilities without GUI
software_general_repo_non_gui=" doxygen checkinstall lm-sensors cmake valgrind \
gcc clang llvm emacs build-essential htop net-tools  minicom screen python3-pip"

# list of software with GUI
software_with_gui=" gksu terminator guake ddd evince synaptic psensor gufw xpad \
unity-tweak-tool libreoffice-style-hicontrast unattended-upgrades gparted \
libappindicator1 libindicator7 hardinfo chromium-browser moserial libncurses* python-gpgme "

# list of dropped app
software_dropped=" gitg"

# all tool chains and utilities
arm_toolchain="gdb-arm-none-eabi openocd qemu gcc-arm-none-eabi"
avr_arduino_toolchain="avrdude avr-libc simulavr"

source ../utils.sh
DEBUG=1 # set 0 to enable debug, 1 by defaults
# Configuration Parameters
wsl=1 # 0 for installing on Window Subsystem for Linux, 1 for not wsl by default
set -e 
set -o pipefail
set -o nounset
#----------------------------------------------------------------------------------------------------
# Default execution commands starts here

# disable root account
sudo passwd -l root

# Handling input options
while [ -n "$1" ]
do
    case "$1" in
        -h) printf "${green} program used for setting up new Debian based system \
        -wsl is for selecting wsl options \
        -h prints help\n ${reset}";;
        -wsl) wsl=0;;
        -debug) DEBUG=0;;
        *) print_message "Not a valid option ";;
    esac
    shift
done
if [[ DEBUG = 0 ]]; then
set -e # exit when there is an error, replaced with specific error handling
fi
printf "\n ${cyan} ---------BASIC-----------\n ${reset}"
print_message "Starting $(basename $0)\n " # extract base name from $0
cd # back to home directory

if [ $wsl -eq 1 ] ; then
if sudo ufw enable; then
print_message "Firewall Enabled\n"
sleep 4
else
print_error "Firewall failed to enable\n "
exit 1
sleep 4
fi
fi

# setup GNOME keyring git credential helper
sudo apt-get install libgnome-keyring-dev
sudo make --directory=/usr/share/doc/git/contrib/credential/gnome-keyring/
git config --global credential.helper /usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring

# setting up git account info
git config --global push.default simple
print_message " Please enter git user name \n"
read name
git config --global user.name $name
print_message " Your git user name is"
git config --global user.name
printf "\n"
print_message " Please enter git email address\n"
read email
git config --global user.email $email
print_message " Your git email is"
git config --global user.email
printf "\n"
sleep 4

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

sudo dpkg-reconfigure unattended-upgrades

# Added access to usb ports for current user
sudo usermod -a -G dialout ${USER}

#----------------------------------------------------------------------------------------------------
# Auxilarry customizations start here
printf "${cyan}\n--------AUXILLARY------------\n ${reset}"


if [ $wsl -eq 1 ]; then
# customizing the shell prompt
sed -i '/force_color_prompt/s/# //' ~/.bashrc # force color prompt, -i for in place manipulations
if [ ! -d ~/Workspace/ ]; then
mkdir ~/Workspace # create workspace dir for Visual Studio Code at home dir
fi

if [ ! -d ~/temp/ ]; then
mkdir ~/temp #  temp dir for basic scratch work
fi

# customize the terminal
cp ~/Linux_Setup/Debian_Setup/terminator/config ~/.config/terminator/config # replace config files of terminator over the old one.
fi

if [ -f /etc/os-release ]; then
source /etc/os-release # obtain env var about system
if [ "${NAME}" = "Ubuntu" ]; then
# install theme
print_message "Which theme do you want? Make sure the PPAs are still legit\n"
print_message "1\\Obsidian green     2\\Flatabulous with Ultra-Flat theme\n"
read THEME_CHOICE

case ${THEME_CHOICE} in
1) 
sudo add-apt-repository ppa:noobslab/themes
sudo apt-get update
sudo apt-get install obsidian-gtk-theme
gsettings set org.gnome.desktop.interface gtk-theme "Obsidian-1-green";;

2) 
sudo add-apt-repository ppa:noobslab/themes
sudo add-apt-repository ppa:noobslab/icons
sudo apt-get update
sudo apt-get install ultra-flat-icons
sudo apt-get install flatabulous-theme
gsettings set org.gnome.desktop.interface gtk-theme "Flatabulous"
gsettings set org.gnome.desktop.interface icon-theme Ultra-Flat;;

esac
fi
fi

print_message "Auxilarry customizations done\n"
sleep 4

#----------------------------------------------------------------------------------------------------
# Dev tools installations start here
printf "\n ${cyan}--------DEV-TOOLS----------- ${reset}"
printf "${cyan}\n Basic Install is done, please select additional install options separated by space: \n${reset}"
printf  "${cyan}1/ARM 2/AVR 3/Java${reset}"
read input

# handle options
for option in ${input}; do
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
    sudo apt-get update > /dev/null
    sudo apt-get install gradle > /dev/null
    sudo apt-get install oracle-java8-installer > /dev/null;;
esac
done 
sudo apt autoremove -y

#----------------------------------------------------------------------------------------------------
# Post installtion messages start here
exit 0
