#!/bin/bash 
#scripts written for setting up a fresh Debian based system
#chmod u+x setup.sh will make the file executable for only owner 

#----------------------------------------------------------------------------------------------------
#Variables start here 
#Modify software lists here
#NO SPACE AROUND '=' for variable assignment
SOFTWARE_GENERAL_REPO="checkinstall lm-sensors psensor cmake \
                        gufw valgrind gcc clang llvm terminator\
                        emacs synaptic build-essential gitg htop\
                        net-tools evince gksu guake ddd"
                        #list of general utilities

ARM_TOOLCHAIN="gdb-arm-none-eabi openocd qemu gcc-arm-none-eabi"
AVR_ARDUINO_TOOLCHAIN="arduino avrdude avr-libc simulavr"
FULL="$ARM_TOOLCHAIN $AVR_ARDUINO_TOOLCHAIN" #all tool chains and utilities

SOFTWARE_GENERAL_NONREPO="\nFoxit_Reader Visual_Studio_Code\nSophos Veeam\n"

#Color Variables for output, chosen for best visibility
#Consult the Xterm 256 color charts for more code 
#format is \33 then <fg_bg_code>;5;<color code>m 38 for foreground, 48 for background
RED='\33[38;5;0196m'
CYAN='\033[38;5;87m' #for marking the being of a new sections
YELLOW='\033[38;5;226m' #for error 
GREEN='\033[38;5;154m' #for general messages

#----------------------------------------------------------------------------------------------------
#Execution commands starts here
#Always execute these
#set -e #exit when there is an error, replaced with specific error handling  
echo "\n{CYAN}---------BASIC-----------"
printf  "starting %s" "$(basename $0)" #extract base name from $0
cd #back to home directory 
sudo ufw enable #enable firewall 

#update the system, only proceed if the previous command is successful  
if [(sudo apt-get update\
&& sudo apt-get dist-upgrade\
&& sudo apt-get install $SOFTWARE_GENERAL_REPO) -ne 0]; then
printf "\n${YELLOW}Failed in Basic update and install\n"
exit 1 
fi 

#----------------------------------------------------------------------------------------------------
#Auxilarry customizations start here
echo "\n{CYAN}--------AUXILLARY------------"
mkdir ~/Workspace #create workspace dir for Visual Studio Code at home dir

#used for non-WSL install 
#customizing the shell prompt
#sed -i '/force_color_prompt/s/#//' ~/.bashrc #enable color prompt, -i for in place manipulations 

#customize the terminal 
#cp ~/Linux_Setup/Debian_Setup/terminator_config ~/.config/terminator/config #replace config files of terminator over the old one. 

#----------------------------------------------------------------------------------------------------
#Dev tools installations start here
echo "\n{CYAN}--------DEV-TOOLS-----------"
printf "\n${CYAN}Basic Install is done, please select additional install options:\n"
printf  "${CYAN}1/Full 2/ARM 3/AVR " 
read option

case $option in #handle options
    1) echo "\n${GREEN}installing $FULL\n" 
    if ! sudo apt-get install $FULL; then
    printf "\n${YELLOW}Failed to install full package\n" 
    exit 1
    fi;;
    2) echo "\n${GREEN}installing $ARM_TOOLCHAIN\n"
    if ! sudo apt-get install $ARM_TOOLCHAIN; then 
    printf "\n${YELLOW}Failed to install ARM toolchain\n" 
    exit 1
    fi ;;
    3) echo "\n${GREEN}installing $AVR_ARDUINO_TOOLCHAIN\n"
    if ! sudo apt-get install $AVR_ARDUINO_TOOLCHAIN; then 
    printf "\n${YELLOW}Failed to install AVR toolchain\n"
    exit 1
    fi ;;
    *) printf  "${YELLOW}\nInvalid options\n";;
esac

#----------------------------------------------------------------------------------------------------
#Post installtion messages start here 
echo "\n{CYAN}--------POST-INST-----------"
printf  "${GREEN}\nScript execution is done \n Please install these additional software if needed ${SOFTWARE_GENERAL_NONREPO}" 
exit 0