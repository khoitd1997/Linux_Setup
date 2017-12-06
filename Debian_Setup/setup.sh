#!/bin/bash 
#scripts written for setting up a fresh Debian based system
#chmod u+x setup.sh will make the file executable for only owner 

#----------------------------------------------------------------------------------------------------
#Variables start here 
#Modify software lists here
#NO SPACE AROUND '=' for variable assignment

#list of general utilities without GUI
SOFTWARE_GENERAL_REPO_NON_GUI=" checkinstall lm-sensors cmake valgrind gcc clang llvm  emacs build-essential htop net-tools "

#list of software with GUI                        
SOFTWARE_WITH_GUI= " gksu terminator gitg guake ddd evince synaptic psensor gufw "

#all tool chains and utilities
ARM_TOOLCHAIN="gdb-arm-none-eabi openocd qemu gcc-arm-none-eabi"
AVR_ARDUINO_TOOLCHAIN="arduino avrdude avr-libc simulavr"
FULL="$ARM_TOOLCHAIN $AVR_ARDUINO_TOOLCHAIN" 

#software not in current Ubuntu 16.04 repos
SOFTWARE_GENERAL_NONREPO="\nFoxit_Reader Visual_Studio_Code\nSophos Veeam\n"

#Color Variables for output, chosen for best visibility
#Consult the Xterm 256 color charts for more code 
#format is \33 then <fg_bg_code>;5;<color code>m, 38 for foreground, 48 for background
RED='\33[38;5;0196m' 
CYAN='\033[38;5;087m' #for marking the being of a new sections 
YELLOW='\033[38;5;226m' #for error 
GREEN='\033[38;5;154m' #for general messages 
RESET='\033[0m' #for resetting the color 
DEBUG= 0 #set 0 to enable debug
#Configuration Parameters
WSL=1 #0 for installing on Window Subsystem for Linux, 1 for not WSL by default

#----------------------------------------------------------------------------------------------------
#Default execution commands starts here

#Handling input options
while [ -n "$1" ]
do 
    case "$1" in
        -h) printf "${GREEN} program used for setting up new Debian based system \
        -wsl is for selecting wsl options \
        -h prints help\n ${RESET}";;
        -wsl) WSL=0;; 
        -debug) DEBUG=0;;
        *) printf  "${GREEN}Not a valid option ${RESET}";;
    esac
    shift 
done 
if [[ DEBUG = 0 ]]; then
set -e #exit when there is an error, replaced with specific error handling  
fi
printf "\n ${CYAN} ---------BASIC-----------\n ${RESET}"
printf  "${GREEN}Starting $(basename $0)\n ${RESET}" #extract base name from $0
cd #back to home directory 

if [ $WSL -eq 1 ] ; then
sudo ufw enable #enable firewall 
fi

#update the system, only proceed if the previous command is successful  
if [ $WSL -eq 1 ] ; then
    SOFTWARE_GENERAL_REPO= "${SOFTWARE_GENERAL_REPO_NON_GUI}${SOFTWARE_WITH_GUI}"
else 
    SOFTWARE_GENERAL_REPO="${SOFTWARE_GENERAL_REPO_NON_GUI}"
fi

if sudo apt-get update\
&& sudo apt-get dist-upgrade\
&& sudo apt-get install ${SOFTWARE_GENERAL_REPO} ; then
printf "\n ${YELLOW}Failed in Basic update and install\n ${RESET}"
exit 1 
fi 

#----------------------------------------------------------------------------------------------------
#Auxilarry customizations start here
printf "${CYAN} \n  --------AUXILLARY------------\n ${RESET}"


if [ $WSL -eq 1 ] ; then
#customizing the shell prompt
sed -i '/force_color_prompt/s/#//' ~/.bashrc #force color prompt, -i for in place manipulations 

mkdir ~/Workspace #create workspace dir for Visual Studio Code at home dir 

#customize the terminal 
#cp ~/Linux_Setup/Debian_Setup/terminator_config ~/.config/terminator/config #replace config files of terminator over the old one. 
fi 

#----------------------------------------------------------------------------------------------------
#Dev tools installations start here
printf "\n ${CYAN}--------DEV-TOOLS----------- ${RESET}"
printf "${CYAN}\n Basic Install is done, please select additional install options: \n ${RESET}"
printf  "${CYAN}1/Full 2/ARM 3/AVR ${RESET}" 
read option

case $option in #handle options
    1) printf "${GREEN}\n installing $FULL\n ${RESET}" 
    if ! sudo apt-get install $FULL; then
    printf "${YELLOW}\n Failed to install full package\n ${RESET}" 
    exit 1
    fi;;
    2) printf "${GREEN}\n installing $ARM_TOOLCHAIN\n ${RESET}"
    if ! sudo apt-get install $ARM_TOOLCHAIN; then 
    printf "${YELLOW}\n Failed to install ARM toolchain\n ${RESET}" 
    exit 1
    fi ;;
    3) printf "\n ${GREEN}installing $AVR_ARDUINO_TOOLCHAIN\n ${RESET}"
    if ! sudo apt-get install $AVR_ARDUINO_TOOLCHAIN; then 
    printf "\n ${YELLOW}Failed to install AVR toolchain\n ${RESET}"
    exit 1
    fi ;;
    *) printf  "${YELLOW}\nInvalid options\n ${RESET}"
        exit 1;;
esac

#----------------------------------------------------------------------------------------------------
#Post installtion messages start here 
printf "\n ${CYAN} --------POST-INST-----------\n ${RESET}"
printf  " ${GREEN} Script successfully executed \nPlease install these additional software if needed ${SOFTWARE_GENERAL_NONREPO} ${RESET}" 
exit 0