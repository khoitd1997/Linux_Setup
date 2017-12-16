#!/bin/bash 
#scripts written to quickly install visual studio code extensions

#----------------------------------------------------------------------------------------------------
#essential extensions that will always be installed
EXTENSIONS_GENERAL=" ms-vscode.cpptools "

#specialized dev tools
EXTENSIONS_PYTHON=""
EXTENSIONS_DOXYGEN=""

#Color Variables for output, chosen for best visibility
#Consult the Xterm 256 color charts for more code 
#format is \33 then <fg_bg_code>;5;<color code>m, 38 for foreground, 48 for background
RED='\33[38;5;0196m' 
CYAN='\033[38;5;087m' #for marking the being of a new sections 
YELLOW='\033[38;5;226m' #for error 
GREEN='\033[38;5;154m' #for general messages 
RESET='\033[0m' #for resetting the color 
DEBUG=1 #set 0 to enable debug, 1 by defaults
SLEEPTIME=3 #delay amount between informative commands

#----------------------------------------------------------------------------------------------------
if ! dpkg-query -l code; then 
 printf "${YELLOW}\nVisual Studio Code not installed\n ${RESET}"
 exit 1
 else
  printf "${GREEN}\nVisual Studio Code found\n ${RESET}" 
 fi  

sleep ${SLEEPTIME}

EXTENSIONS_ALL="${EXTENSIONS_GENERAL}"

if ! code --install-extensions ${EXTENSIONS_ALL}; then 
printf "${YELLOW}\nErrrors while installed extensions\n ${RESET}"
exit 1 
fi

printf "${GREEN}\nInstalled Extensions\n ${RESET}" 
code --list-extensions
exit 0 