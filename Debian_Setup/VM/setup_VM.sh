#!/bin/bash
#scripts written for setting up a fresh Debian VM
#chmod u+x setup.sh will make the file executable for only owner

source ../../utils.sh

software=" calibre ufw "

set -e

print_message "Starting VM setup scripts\n"
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install ${software} -y
sudo ufw enable
sudo ufw status
sleep 5

print_message "Please insert the guest addition cd, you have 15 seconds\n"
sleep 15

kernel_name=$(uname -r)

#deleting the OS built-in guest addition to avoid conflict
sudo rm -rf /lib/modules/${kernel_name}/kernel/ubuntu/vbox/vbox*

current_user="$(logname)"
#run guest addition install
cd /media/${current_user}/VBox_GAs*
sudo ./VBoxLinux*

sudo usermod -a -G vboxsf ${current_user}

print_message "Done installing, rebooting in 5\n"
sleep 5

sudo apt autoremove -y
reboot
