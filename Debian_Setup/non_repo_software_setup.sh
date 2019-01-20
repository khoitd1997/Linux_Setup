#!/bin/bash
# This file serves to install external program currently not in ubuntu repo

source ../utils.sh

software_general_nonrepo=" bat_by_sharkdp \
fd_by_sharkdp \
fzf_by_junegunn
"

#-----------------------------PROMPT-----------------------------------------#
check_dir OS_Setup/Debian_Setup

counter=0
printf "${green}\nList of software to be installed:\n${reset}"
for software in ${software_general_nonrepo}; do 
printf "${reset}%-25s|  " "${software}"
counter=$((++counter))
if !((${counter}%3)); then
printf "\n"
fi
done
print_message "Press any key when you are done with manual installtion\n"
empty_input_buffer()
read input

#----------------------------INSTALLING-----------------------------------#
