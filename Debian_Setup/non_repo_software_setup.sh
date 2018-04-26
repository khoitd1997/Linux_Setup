#!/bin/bash
# This file serves to install external program currently not in ubuntu repo 16.04

source ../utils.sh

software_dropped="Foxit_Reader \
Sophos \
Veeam"

# make sure to have the same name that appear in dpkg -l
software_general_nonrepo="code \
google-chrome-stable \
jlink \
segger_embedded \
gitkraken \
dropbox \
zoom \
discord \
atom \
slack-desktop \
eagle \
matlab \
anyconnect \
virtualbox
"

#-----------------------------PROMPT-----------------------------------------#
check_dir Linux_Setup/Debian_Setup

counter=0
printf "${green}\nList of software to be installed:\n${reset}"
for software in ${software_general_nonrepo}; do 
printf "${reset}%-25s|  " "${software}"
counter=$((++counter))
if !((${counter}%3)); then
printf "\n"
fi
done
printf "${green}\nPress any key when you are done downloading to ~/Downloads${reset}"
read input

#----------------------------INSTALLING-----------------------------------#
printf "${green}Installing\n ${reset}"
sudo apt-get update 
sudo dpkg -i ~/Downloads/*.deb   || true
sudo apt-get -f install 
sudo dpkg -i ~/Downloads/*.deb   || true # run again after all dependency is fixed


# handle software that come in tar format
counter=0
printf "${green}\nPLEASE WAIT TILL DONE, The following software need manual install:\n${reset}"
for software in $(ls ~/Downloads | grep -i .zip); do
mkdir ~/Download/${software%%.zip}
unzip -o ~/Downloads/${software} -d ~/Download/${software%%.zip} 
printf "${cyan}%-35s  |  ${reset}" "${software}"
counter=$((++counter))
if !((${counter}%2)); then
printf "\n"
fi
done

# handle software in ZIP format
for software in $(ls ~/Downloads | grep -i .tar.gz); do
tar -xzf ~/Downloads/${software} -C ~/Downloads
printf "${cyan}%-35s  |  ${reset}" "${software}"
counter=$((++counter))
if !((${counter}%2)); then
printf "\n"
fi
done


printf "${green}\nAutomated install and extraction done, press any key when done with manual install\n${reset}"
read input

#----------------------------CHECKING-------------------------------------#
for software in ${software_general_nonrepo}; do 
dpkg -s ${software} > /dev/null 2>&1
if [ "$?" -eq "0" ]; then 
printf "${reset}You have installed ${green}${software}\n${reset}"
else
# check if it was a type that need to be copied to home dir
if [ -e ${HOME}/${software}* ] \
|| [ -e /usr/share/${software}* ] \
|| [ -e /opt/*/${software}* ] \
|| [ -e /opt/${software}* ]; then 
printf "${reset}You have installed ${green}${software}\n${reset}"
else 
printf "${reset}You haven't installed ${red}${software}\n${reset}"
fi
fi
done
exit 0