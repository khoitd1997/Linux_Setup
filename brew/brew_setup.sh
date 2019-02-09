#!/bin/bash
# setting up brew for Linux, this should be used with wsl setup

software_list=" fzf bat tldr hub "
software_cask=" hyper "

sudo apt-get install build-essential curl file git # build dependency
brew update
brew install ${software_list}
# brew cask install ${software_cask}

$(brew --prefix)/opt/fzf/install # setup fzf keybindings