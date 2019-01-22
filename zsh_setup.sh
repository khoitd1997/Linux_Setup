#!/bin/bash
# written for installation of zsh
source ./utils.sh

zsh_plugin="https://github.com/zsh-users/zsh-completions.git \
            https://github.com/zsh-users/zsh-autosuggestions.git"

#--------------------------------------------------------------------------------------

print_message "Starting zsh installation"
if [ -f "/etc/debian_version" ]; then
    sudo apt update && sudo apt install zsh zsh-syntax-highlighting -y
else
    sudo dnf install zsh zsh-syntax-highlighting -y
fi

# oh-my-zsh stuffs
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

cp zsh/.zshrc ~/.zshrc

# plugins
cd ~/.oh-my-zsh/custom/plugins
for plugin in ${zsh_plugin}; do 
git clone ${plugin}
done

print_message "zsh installation done"
