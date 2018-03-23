#!/bin/bash 
#scripts written to quickly install visual studio code extensions

#----------------------------------------------------------------------------------------------------
#essential extensions that will always be installed
EXTENSIONS_GENERAL="ms-vscode.cpptools vsciot-vscode.vscode-arduino kevinkyang.auto-comment-blocks  
CoenraadS.bracket-pair-colorizer formulahendry.code-runner eamodio.gitlens donjayamanne.githistory huizhou.githd 
 PKief.material-icon-theme webfreak.debug Tyriar.sort-lines wayou.vscode-todo-highlight "

#specialized dev tools
EXTENSIONS_PYTHON=" ms-python.python"
EXTENSIONS_DOXYGEN=" bbenoist.doxygen cschlosser.doxdocgen "
EXTENSIONS_ARM=" dan-c-underwood.arm "
EXTENSIONS_VHDL=" puorc.awesome-vhdl "
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

EXTENSIONS_ALL="${EXTENSIONS_GENERAL}"
printf "${GREEN}\nPlease input the number of chosen options separated by space\n ${RESET}" 
printf "${GREEN}\n 1/Python\n ${RESET}"
printf "${GREEN}\n 2/Doxygen\n ${RESET}"
printf "${GREEN}\n 3/ARM MCU\n ${RESET}"
printf "${GREEN}\n 4/VHDL\n ${RESET}"
read input 
for var in ${input}
do 
    case $var in 
    1)EXTENSIONS_ALL="${EXTENSIONS_ALL}${EXTENSIONS_PYTHON}";;
    2)EXTENSIONS_ALL="${EXTENSIONS_ALL}${EXTENSIONS_DOXYGEN}";;
    3)EXTENSIONS_ALL="${EXTENSIONS_ALL}${EXTENSIONS_ARM}";;
    4)EXTENSIONS_ALL="${EXTENSIONS_ALL}${EXTENSIONS_VHDL}";;
    *) ;;
esac
done

for ext in ${EXTENSIONS_ALL}
do 
if ! code --install-extension "${ext}"; then 
printf "${YELLOW}\nErrrors while installing extensions\n ${RESET}"
exit 1 
fi
done

printf "${GREEN}\nInstalled Extensions\n ${RESET}" 
code --list-extensions

#copy Visual Studdio Code setting file
cp -f ~/Linux_Setup/Debian_Setup/VisualCode/settings.json $HOME/.config/Code/User/s

printf "${GREEN}\nVisual Studio Code Configurations done\n ${RESET}" 
exit 0 