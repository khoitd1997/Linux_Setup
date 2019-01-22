#!/bin/bash
# install and config the hyper terminal

source ./utils.sh
set -e 
set -o pipefail
set -o nounset
#----------------------------------------------------------------------------------------------------

print_message "Press anykey when done installing hyper for your platform\n"
empty_input_buffer
read done_signal

OS="$(uname -s)"
cp hyper/.hyper.js temp.js

if [ "${OS}" == "Linux" ] ; then
sed -i '/Program Files/s/^/\/\//' temp.js
sed -i '/bash.exe/s/^/\/\//' temp.js
sed -i '/msys/s/^/\/\//' temp.js
hyper_config_dir="${HOME}"
else
sed -i "/shell: '',/s/^/\/\//" temp.js
sed -i "/--login/s/^/\/\//" temp.js
# hyper_config_dir="$APPDATA/Hyper/"
hyper_config_dir="/c/Users/khoid" # change this based on user name
fi

mv -v temp.js ${hyper_config_dir}/.hyper.js
print_message "Hyper installation done\n"
