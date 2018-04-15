#!/bin/bash
# This file serves to install external program currently not in ubuntu repo 16.04

# Color Variables for output, chosen for best visibility
# Consult the Xterm 256 color charts for more code
# format is \33 then <fg_bg_code>;5;<color code>m, 38 for foreground, 48 for background
RED='\33[38;5;0196m'
CYAN='\033[38;5;087m' #for marking the being of a new sections
YELLOW='\033[38;5;226m' #for error
GREEN='\033[38;5;154m' #for general messages
RESET='\033[0m' #for resetting the color

SOFTWARE_DROPPED="Foxit_Reader \
Sophos \
Veeam"

# make sure to have the same name that appear in dpkg -l
SOFTWARE_GENERAL_NONREPO="code \
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
anyconnect
"
set -e 
set -o pipefail
set -o nounset
#-----------------------------PROMPT-----------------------------------------#
counter=0
printf "${GREEN}\nList of software to be installed:\n${RESET}"
for software in ${SOFTWARE_GENERAL_NONREPO}; do 
printf "${RESET}%-25s|  " "${software}"
counter=$((++counter))
if !((${counter}%3)); then
printf "\n"
fi
done
printf "${GREEN}\nPress any key when you are done downloading to ~/Downloads${RESET}"
read INPUT

#----------------------------INSTALLING-----------------------------------#
printf "${GREEN}Installing\n ${RESET}"
sudo apt-get update > /dev/null
sudo dpkg -i ~/Downloads/*.deb > /dev/null 2>&1 || true
sudo apt-get -f install > /dev/null
sudo dpkg -i ~/Downloads/*.deb > /dev/null 2>&1 || true # run again after all dependency is fixed


# handle software that come in tar format
counter=0
printf "${GREEN}\nPLEASE WAIT TILL DONE, The following software need manual install:\n${RESET}"
for software in $(ls ~/Downloads | grep -i .tar.gz); do
mkdir ~/Download/${software%%.zip}
unzip -o ~/Downloads/${software} -d ~/Download/${software%%.zip} > /dev/null
printf "${CYAN}%-35s  |  ${RESET}" "${software}"
counter=$((++counter))
if !((${counter}%2)); then
printf "\n"
fi
done

# handle software in ZIP format
for software in $(ls ~/Downloads | grep -i .zip); do
tar -xzf ~/Downloads/${software} -C ~/Downloads
printf "${CYAN}%-35s  |  ${RESET}" "${software}"
counter=$((++counter))
if !((${counter}%2)); then
printf "\n"
fi
done


printf "${GREEN}\nAutomated install and extraction done, press any key when done with manual install\n${RESET}"
read INPUT

#----------------------------CHECKING-------------------------------------#
for software in ${SOFTWARE_GENERAL_NONREPO}; do 
dpkg -s ${software} > /dev/null 2>&1
if [ "$?" -eq "0" ]; then 
printf "${RESET}You have installed ${GREEN}${software}\n${RESET}"
else
# check if it was a type that need to be copied to home dir
if [ -e ${HOME}/${software}* ] \
|| [ -e /usr/share/${software}* ] \
|| [ -e /opt/*/${software}* ] \
|| [ -e /opt/${software}* ]; then 
printf "${RESET}You have installed ${GREEN}${software}\n${RESET}"
else 
printf "${RESET}You haven't installed ${RED}${software}\n${RESET}"
fi
fi
done
exit 0