#!/bin/bash
# scripts written to quickly prepare

software=" dos2unix gcc clang llvm build-essential python3-pip python3 ranger tldr neofetch "
wslString=$(uname -r | sed -n 's/.*\( *Microsoft *\).*/\1/p')

#--------------------------------------------------------

sudo apt-get update\
&& sudo apt-get dist-upgrade -y\
&& sudo apt-get install ${software}