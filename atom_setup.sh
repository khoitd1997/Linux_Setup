#!/bin/bash
# scripts written to quickly install atom extensions

source utils.sh
package=" linter linter-gcc gpp-compiler busy-signal intentions linter-ui-default \
minimap code-peek minimap-codeglance git-plus file-icons minimap-highlight-selected highlight-selected \
language-arm tree-view-git-status git-log git-time-machine language-log markdown-writer language-markdown "

atom_config_script_dir="${HOME}/OS_Setup/Atom"
atom_config_file_dir="${HOME}/.atom"

set -e 
set -o pipefail
set -o nounset

OS="$(uname -s)"

#-------------------------------------------------------------------------------------------

check_dir OS_Setup

print_message "Beginning installation of atom packages, make sure you have atom installed\n"

apm install 
apm install ${package} 

atom . # open editor so that it creates a setting file, then we can overwite it
sleep 5

cp -vf ${atom_config_script_dir}/config.cson ${atom_config_file_dir}/
cp -vf ${atom_config_script_dir}/keymap.cson ${atom_config_file_dir}/

print_message "Package Installation and Config Done\n"
