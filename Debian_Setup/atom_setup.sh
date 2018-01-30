#!/bin/bash
#scripts written to quickly install atom extensions

RED='\33[38;5;0196m'
CYAN='\033[38;5;087m' #for marking the being of a new sections
YELLOW='\033[38;5;226m' #for error
GREEN='\033[38;5;154m' #for general messages
RESET='\033[0m' #for resetting the color
DEBUG=1 #set 0 to enable debug, 1 by defaults

PACKAGE=" linter linter-gcc gpp-compiler busy-signal intentions linter-ui-default minimap code-peek minimap-codeglance git-plus "

set -e

printf  "${GREEN}Beginning installation of atom packages, make sure you have atom installed\n ${RESET}"

apm install
apm install ${PACKAGE}

printf  "${GREEN}Package Installation Done\n ${RESET}"
