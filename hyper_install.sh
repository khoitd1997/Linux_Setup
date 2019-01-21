#!/bin/bash
# install and config the hyper terminal

source utils.sh
set -e 
set -o pipefail
set -o nounset
#----------------------------------------------------------------------------------------------------

print_message "Press anykey when done installing hyper for your platform"
empty_input_buffer
read done_signal

OS="$(uname -s)"

if [ "${OS}" == "Linux" ] ; then
hyper_config_dir="${HOME}/.hyper.js"
else # window config
hyper_config_dir="$APPDATA/Hyper/"
fi

cp  hyper/.hyper.js ${hyper_config_dir}
