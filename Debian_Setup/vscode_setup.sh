#!/bin/bash
#scripts written to quickly install visual studio code extensions

#----------------------------------------------------------------------------------------------------
#essential extensions that will always be installed
EXTENSIONS_GENERAL="ms-vscode.cpptools  kevinkyang.auto-comment-blocks CoenraadS.bracket-pair-colorizer formulahendry.code-runner eamodio.gitlens donjayamanne.githistory huizhou.githd
 PKief.material-icon-theme webfreak.debug Tyriar.sort-lines wayou.vscode-todo-highlight "

EXTENSIONS_THEME=" akamud.vscode-theme-onedark "

EXTENSIONS_DROPPED=" vsciot-vscode.vscode-arduino"

#specialized dev tools
EXTENSIONS_PYTHON=" ms-python.python"
EXTENSIONS_JAVA=" redhat.java vscjava.vscode-java-debug naco-siren.gradle-language "
EXTENSIONS_DOXYGEN=" bbenoist.doxygen cschlosser.doxdocgen "
EXTENSIONS_ARM=" dan-c-underwood.arm "
EXTENSIONS_VHDL=" puorc.awesome-vhdl "
EXTENSIONS_MD=" mushan.vscode-paste-image DavidAnson.vscode-markdownlint yzhang.markdown-all-in-one hnw.vscode-auto-open-markdown-preview shd101wyy.markdown-preview-enhanced "
EXTENSIONS_WEB=" formulahendry.auto-close-tag "

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

EXTENSIONS_ALL="${EXTENSIONS_GENERAL}${EXTENSIONS_THEME}"
clear
printf "${GREEN}\nPlease input the number of chosen options separated by space\n ${RESET}"
printf "${GREEN}\n1/Python\n ${RESET}"
printf "${GREEN}\n2/Doxygen\n ${RESET}"
printf "${GREEN}\n3/ARM MCU\n ${RESET}"
printf "${GREEN}\n4/VHDL\n ${RESET}"
printf "${GREEN}\n5/Java, Gradle\n ${RESET}"
printf "${GREEN}\n6/Mark Down\n ${RESET}"
printf "${GREEN}\n7/Html, typescript, javascript\n ${RESET}"
read input
for var in ${input}
do
    case $var in
    1)EXTENSIONS_ALL="${EXTENSIONS_ALL}${EXTENSIONS_PYTHON}";;
    2)EXTENSIONS_ALL="${EXTENSIONS_ALL}${EXTENSIONS_DOXYGEN}";;
    3)EXTENSIONS_ALL="${EXTENSIONS_ALL}${EXTENSIONS_ARM}";;
    4)EXTENSIONS_ALL="${EXTENSIONS_ALL}${EXTENSIONS_VHDL}";;
    5)EXTENSIONS_ALL="${EXTENSIONS_ALL}${EXTENSIONS_JAVA}";;
    6)EXTENSIONS_ALL="${EXTENSIONS_ALL}${EXTENSIONS_MD}";;
    7)EXTENSIONS_ALL="${EXTENSIONS_ALL}${EXTENSIONS_WEB}";;
    *) ;;
esac
done

printf "${GREEN}Starting Package Installation\n ${RESET}"
for ext in ${EXTENSIONS_ALL}
do
if ! code --install-extension "${ext}" >> /dev/null ; then
printf "${YELLOW}\nErrrors while installing extensions\n ${RESET}"
exit 1
fi
done

printf "${GREEN}Installation Done\n ${RESET}"
code --list-extensions

#copy Visual Studdio Code setting file and keybinding file
cp -f ~/Linux_Setup/Debian_Setup/VisualCode/settings.json ~/.config/Code/User/settings.json
cp -f ~/Linux_Setup/Debian_Setup/VisualCode/keybindings.json ~/.config/Code/User/keybindings.json

printf "${GREEN}Visual Studio Code Configurations done\n ${RESET}"
exit 0
