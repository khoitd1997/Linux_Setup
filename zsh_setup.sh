#!/bin/bash
# written for installation of zsh
source utils.sh

zsh_plugin="https://github.com/zsh-users/zsh-completions.git \
            https://github.com/zsh-users/zsh-autosuggestions.git"

#--------------------------------------------------------------------------------------

print_message "Starting zsh installation"

# oh-my-zsh stuffs
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

cp zsh/.zshrc ~/.zshrc

# plugins
cd ~/.oh-my-zsh/custom/plugins
for plugin in ${zsh_plugin}; do 
git clone ${plugin}
done

print_message "zsh installation done"
