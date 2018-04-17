#!/bin/bash
# scripts written to quickly install atom extensions

source ../utils.sh
package=" linter linter-gcc gpp-compiler busy-signal intentions linter-ui-default \
minimap code-peek minimap-codeglance git-plus file-icons minimap-highlight-selected highlight-selected \
language-arm tree-view-git-status git-log git-time-machine language-log"
dependencies=" nodejs* "

atom_config_script_dir="~/Linux_Setup/Debian_Setup/Atom"
atom_config_file_dir="~/.atom"

set -e 
set -o pipefail
set -o nounset
#-------------------------------------------------------------------------------------------

print_message "Installing atom dependencies\n"
sudo apt-get update >> /dev/null
sudo apt-get dist-upgrade ${dependencies} >> /dev/null


print_message "Beginning installation of atom packages, make sure you have atom installed\n"

apm install >> /dev/null
apm install ${package} /dev/null

cp -f ${atom_config_script_dir}/settings.json ${atom_config_file_dir}/keymap.cson
cp -f ${atom_config_script_dir}/keybindings.json ${atom_config_file_dir}/config.cson

print_message "Package Installation and Config Done\n"
