#!/bin/bash
#scripts written for setting up a fresh Debian VM
#chmod u+x setup.sh will make the file executable for only owner

RED='\33[38;5;0196m'
CYAN='\033[38;5;087m' #for marking the being of a new sections
YELLOW='\033[38;5;226m' #for error
GREEN='\033[38;5;154m' #for general messages
RESET='\033[0m' #for resetting the color

SOFTWARE=" calibre ufw "

set -e

printf "${GREEN}\nStarting VM setup scripts\n ${RESET}"
sudo apt remove libappstream3
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install ${SOFTWARE} -y
sudo ufw enable
sudo ufw status
sleep 5

printf "${GREEN}\n Please insert the guest addition cd, you have 15 seconds\n ${RESET}"
sleep 15

KERNEL_NAME=$(uname -r)
REGULAR_NAME=${USER}

#deleting the OS built-in guest addition to avoid conflict
sudo sh -c "rm -rf /lib/modules/${KERNEL_NAME}/vbox*"


#run guest addition install
cd /media/{REGULAR_NAME}/VBox*
./VBoxLinux*

sudo usermod -a -G vboxsf ${REGULAR_NAME}

printf "${GREEN}\nDone installing, rebooting in 5\n ${RESET}"
sleep 5
reboot
