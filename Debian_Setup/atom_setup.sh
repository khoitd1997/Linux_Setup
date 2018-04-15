#!/bin/bash
#scripts written to quickly install atom extensions

RED='\33[38;5;0196m'
CYAN='\033[38;5;087m' #for marking the being of a new sections
YELLOW='\033[38;5;226m' #for error
GREEN='\033[38;5;154m' #for general messages
RESET='\033[0m' #for resetting the color

PACKAGE=" linter linter-gcc gpp-compiler busy-signal intentions linter-ui-default \
minimap code-peek minimap-codeglance git-plus file-icons minimap-highlight-selected highlight-selected \
language-arm tree-view-git-status git-log git-time-machine language-log"
DEPENDENCIES=" nodejs* "

ATOM_CONFIG_SCRIPT_DIR="~/Linux_Setup/Debian_Setup/Atom"
ATOM_CONFIG_FILE_DIR="~/.atom"

set -e 
set -o pipefail
set -o nounset
#-------------------------------------------------------------------------------------------

printf  "${GREEN}Installing atom dependencies\n ${RESET}"
sudo apt-get update >> /dev/null
sudo apt-get dist-upgrade ${DEPENDENCIES} >> /dev/null


printf  "${GREEN}Beginning installation of atom packages, make sure you have atom installed\n ${RESET}"

apm install >> /dev/null
apm install ${PACKAGE} /dev/null

cp -f ${ATOM_CONFIG_SCRIPT_DIR}/settings.json ${ATOM_CONFIG_FILE_DIR}/keymap.cson
cp -f ${ATOM_CONFIG_SCRIPT_DIR}/keybindings.json ${ATOM_CONFIG_FILE_DIR}/config.cson

printf  "${GREEN}\nPackage Installation and Config Done\n ${RESET}"
