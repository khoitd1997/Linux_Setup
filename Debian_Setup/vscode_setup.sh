#!/bin/bash
# scripts written to quickly install visual studio code extensions

#----------------------------------------------------------------------------------------------------
# essential extensions that will always be installed
EXTENSIONS_GENERAL="ms-vscode.cpptools  kevinkyang.auto-comment-blocks CoenraadS.bracket-pair-colorizer formulahendry.code-runner \
eamodio.gitlens donjayamanne.githistory huizhou.githd PKief.material-icon-theme webfreak.debug Tyriar.sort-lines \
wayou.vscode-todo-highlight emilast.logfilehighlighter "

EXTENSIONS_THEME=" zhuangtongfa.material-theme "

EXTENSIONS_DROPPED=" vsciot-vscode.vscode-arduino"

# specialized dev tools
EXTENSIONS_PYTHON=" ms-python.python"
EXTENSIONS_JAVA=" redhat.java vscjava.vscode-java-debug naco-siren.gradle-language "
EXTENSIONS_DOXYGEN=" bbenoist.doxygen cschlosser.doxdocgen "
EXTENSIONS_ARM=" dan-c-underwood.arm "
EXTENSIONS_VHDL=" puorc.awesome-vhdl "
EXTENSIONS_MD=" mushan.vscode-paste-image DavidAnson.vscode-markdownlint yzhang.markdown-all-in-one \
hnw.vscode-auto-open-markdown-preview shd101wyy.markdown-preview-enhanced "
EXTENSIONS_WEB=" formulahendry.auto-close-tag "

# Color Variables for output, chosen for best visibility
# Consult the Xterm 256 color charts for more code
# format is \33 then <fg_bg_code>;5;<color code>m, 38 for foreground, 48 for background
RED='\33[38;5;0196m'
CYAN='\033[38;5;087m' # for marking the being of a new sections
YELLOW='\033[38;5;226m' # for error
GREEN='\033[38;5;154m' # for general messages
RESET='\033[0m' # for resetting the color
DEBUG=1 # set 0 to enable debug, 1 by defaults
SLEEPTIME=3 # delay amount between informative commands

set -e 
set -o pipefail
set -o nounset

#----------------------------------------------------------------------------------------------------
if ! dpkg-query -l code; then
print_error "Visual Studio Code not installed\n"
 exit 1
 else
print_message "Visual Studio Code found\n "
 fi

EXTENSIONS_ALL="${EXTENSIONS_GENERAL}${EXTENSIONS_THEME}"
clear
print_message "Please input the number of chosen options separated by space\n"
print_message "1/Python\n"
print_message "2/Doxygen\n"
print_message "3/ARM MCU\n"
print_message "4/VHDL\n"
print_message "5/Java, Gradle\n"
print_message "6/Mark Down\n"
print_message "7/Html, typescript, javascript\n"
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

print_message "Starting Package Installation\n"
for ext in ${EXTENSIONS_ALL}
do
if ! code --install-extension "${ext}" >> /dev/null ; then
print_error "Errrors while installing extensions\n"
exit 1
fi
done

print_message "Installation Done\n"
code --list-extensions

# copy Visual Studdio Code setting file and keybinding file
cp -f ~/Linux_Setup/Debian_Setup/VisualCode/settings.json ~/.config/Code/User/settings.json
cp -f ~/Linux_Setup/Debian_Setup/VisualCode/keybindings.json ~/.config/Code/User/keybindings.json

print_message "Visual Studio Code Configurations done\n"
exit 0
