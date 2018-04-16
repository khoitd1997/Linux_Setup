#!/bin/bash
# scripts written for setting up a fresh Debian based system
# chmod u+x setup.sh will make the file executable for only owner

#----------------------------------------------------------------------------------------------------
# Variables start here
# Modify software lists here
# NO SPACE AROUND '=' for variable assignment

# list of general utilities without GUI
SOFTWARE_GENERAL_REPO_NON_GUI=" doxygen checkinstall lm-sensors cmake valgrind \
gcc clang llvm emacs build-essential htop net-tools  minicom screen python3-pip"

# list of software with GUI
SOFTWARE_WITH_GUI=" gksu terminator guake ddd evince synaptic psensor gufw xpad \
unity-tweak-tool libreoffice-style-hicontrast unattended-upgrades gparted \
libappindicator1 libindicator7 hardinfo chromium-browser moserial libncurses* python-gpgme "

# list of dropped app
SOFTWARE_DROPPED=" gitg"

# all tool chains and utilities
ARM_TOOLCHAIN="gdb-arm-none-eabi openocd qemu gcc-arm-none-eabi"
AVR_ARDUINO_TOOLCHAIN="avrdude avr-libc simulavr"
FULL="$ARM_TOOLCHAIN $AVR_ARDUINO_TOOLCHAIN"

# Color Variables for output, chosen for best visibility
# Consult the Xterm 256 color charts for more code
# format is \33 then <fg_bg_code>;5;<color code>m, 38 for foreground, 48 for background
RED='\33[38;5;0196m'
CYAN='\033[38;5;087m' # for marking the being of a new sections
YELLOW='\033[38;5;226m' # for error
GREEN='\033[38;5;154m' # for general messages
RESET='\033[0m' # for resetting the color
DEBUG=1 # set 0 to enable debug, 1 by defaults
# Configuration Parameters
WSL=1 # 0 for installing on Window Subsystem for Linux, 1 for not WSL by default
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
        -h) printf "${GREEN} program used for setting up new Debian based system \
        -wsl is for selecting wsl options \
        -h prints help\n ${RESET}";;
        -wsl) WSL=0;;
        -debug) DEBUG=0;;
print_message "Not a valid option ";;
    esac
    shift
done
if [[ DEBUG = 0 ]]; then
set -e # exit when there is an error, replaced with specific error handling
fi
printf "\n ${CYAN} ---------BASIC-----------\n ${RESET}"
print_message "Starting $(basename $0)\n " # extract base name from $0
cd # back to home directory

if [ $WSL -eq 1 ] ; then
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
if [ $WSL -eq 1 ] ; then
    SOFTWARE_GENERAL_REPO="${SOFTWARE_GENERAL_REPO_NON_GUI}${SOFTWARE_WITH_GUI}"
else
    SOFTWARE_GENERAL_REPO="${SOFTWARE_GENERAL_REPO_NON_GUI}"
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
printf "${CYAN} \n  --------AUXILLARY------------\n ${RESET}"


if [ $WSL -eq 1 ] ; then
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


print_message "Auxilarry customizations done\n"
sleep 4

#----------------------------------------------------------------------------------------------------
# Dev tools installations start here
printf "\n ${CYAN}--------DEV-TOOLS----------- ${RESET}"
printf "${CYAN}\n Basic Install is done, please select additional install options separated by space: \n${RESET}"
printf  "${CYAN}1/ARM 2/AVR 3/Java${RESET}"
read input

# handle options
for option in ${input}; do
case $option in 
    1) 
print_message "Installing ARM\n"
    if ! sudo apt-get install $ARM_TOOLCHAIN; then
print_error "Failed to install ARM toolchain\n"
    exit 1
    fi ;;
    2) 
print_message "Installing AVR\n "
    if ! sudo apt-get install $AVR_ARDUINO_TOOLCHAIN; then
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
