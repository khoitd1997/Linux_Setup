#!/bin/bash 
#scripts written for setting up a fresh Debian system
#chmod u+x setup.sh will make the file executable for only owner 

#Modify software lists here
SOFTWARE_GENERAL_REPO= checkinstall lm-sensors psensor cmake \
                        gufw valgrind gcc clang llvm terminator\
                        emacs synaptic build-essential gitg htop\
                        net-tools evince gksudo guake
                        #list of general utilities

ARM_TOOLCHAIN= gdb-arm-none-eabi openocd qemu gcc-arm-none-eabi
AVR_ARDUINO_TOOLCHAIN= arduino avrdude avr-libc simulavr
FULL= $ARM_TOOLCHAIN $AVR_ARDUINO_TOOLCHAIN #all tool chains and utilities

SOFTWARE_GENERAL_NONREPO=\nFoxit_Reader Visual_Studio_Code\nSophos Veeam

#Execution commands starts here
#Always execute these
printf  "starting %s" "$(basename $0)" #extract base name from $0
cd #back to home directory 
sudo ufw enable #enable firewall 

#update the system 
sudo apt-get update 
sudo apt-get dist-upgrade
sudo apt-get install $SOFTWARE_GENERAL_REPO

#create directory
mkdir /Documents/workspace

#customizing the shell prompt
sed -i '/force_color_prompt/s/#//' ~/.bashrc #enable color prompt, -i for in place manipulations 

#customize the terminal 
cp ~/Linux_Setup/Debian_Setup/terminator_config ~/.config/terminator/config #replace config files of terminator over the old one. 

printf "/n Basic Install is done, please select additional install options:"

printf  "1/Full 2/ARM 3/AVR" 
read option
case $option in #handle options
    1) sudo apt-get install $FULL;;
    2) sudo apt-get install $ARM_TOOLCHAIN;;
    3) sudo apt-get install $AVR_ARDUINO_TOOLCHAIN;;
    *) printf  "\nInvalid options"
       break;;
esac

printf  "\nScript execution is done \n Please install these additional software if needed %s ", "$SOFTWARE_GENERAL_NONREPO" 
exit 0