#!/bin/bash
# scripts written for setting up a fresh RPM based system

#----------------------------------------------------------------------------------------------------
# Variables start here
# Modify software lists here

# fedora software group
software_group=" @development-tools fedora-workstation-repositories "

software_dropped_not_in_repo=" checkinstall build-essential gufw hardinfo "

# list of general utilities without GUI
software_general_repo_non_gui=" doxygen cmake valgrind \
gcc clang llvm htop net-tools  minicom screen python3-pip curl \
python3-setuptools ranger tldr the_silver_searcher neofetch task autojump \
google-chrome-stable xorg-x11-drv-nvidia akmod-nvidia fd-find bat fzf hub git \
nano dnf-automatic openconnect "

# list of software with GUI
software_with_gui=" xclip evince synaptic xpad gparted moserial libncurses* meld \
bustle d-feet graphviz npm flameshot feh nautilus-dropbox"

software_non_fedora_repo=" lpf-spotify-client "

flatpak_package=" com.dropbox.Client com.spotify.Client com.discordapp.Discord \
com.axosoft.GitKraken com.slack.Slack "
flatpak_maybe=" com.jetbrains.IntelliJ-IDEA-Community com.google.AndroidStudio "

# all tool chains and utilities
arm_toolchain=" openocd qemu arm-none-eabi-newlib arm-none-eabi-gcc-cs arm-none-eabi-gcc-cs-c++ "
avr_arduino_toolchain="avrdude avr-gcc simulavr avr-binutils "
latex_doxygen_toolchain=" texlive-scheme-basic texlive-collection-latexextra texlive-collection-latexrecommended \
texlive-fonts-extra texlive-collection-xetex "
golang_toolchain=" golang golint "
golang_package=" github.com/ramya-rao-a/go-outline github.com/acroca/go-symbols github.com/mdempsky/gocode github.com/rogpeppe/godef golang.org/x/tools/cmd/godoc github.com/zmb3/gogetdoc golang.org/x/lint/golint github.com/fatih/gomodifytags golang.org/x/tools/cmd/gorename sourcegraph.com/sqs/goreturns golang.org/x/tools/cmd/goimports github.com/cweill/gotests/... golang.org/x/tools/cmd/guru github.com/josharian/impl github.com/haya14busa/goplay/cmd/goplay github.com/uudashr/gopkgs/cmd/gopkgs github.com/davidrjenni/reftools/cmd/fillstruct github.com/alecthomas/gometalinter " # source: https://github.com/Microsoft/vscode-go/wiki/Go-tools-that-the-Go-extension-depends-on

# python pip list
python_pip_package_list=" pylint autopep8 "

source ../utils.sh
set -e 
set -o pipefail
set -o nounset
#----------------------------------------------------------------------------------------------------
print_message "Starting Installation of Fedora Machine"
SOFTWARE_GENERAL_REPO="${software_general_repo_non_gui}${software_with_gui}"
sudo passwd -l root
sudo systemctl status firewalld

sudo dnf update && sudo dnf upgrade -y
sudo dnf install ${software_group} -y
# got from here: https://rpmfusion.org/Configuration/
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf update 

sudo dnf config-manager --set-enabled google-chrome rpmfusion-nonfree-nvidia-driver
sudo dnf groupinstall multimedia -y
sudo dnf groupupdate multimedia -y
sudo dnf groupupdate sound-and-video -y

sudo dnf update
sudo dnf install ${SOFTWARE_GENERAL_REPO} -y

#flatpak
for flatpak in ${flatpak_package} ; do
	sudo flatpak install flathub ${flatpak} -y 
done

for flatpak in ${flatpak_maybe} ; do 
    print_message "Do you want to install ${flatpak} (y/n)"
    empty_input_buffer
    read flatpak_answer
    if [ ${flatpak_answer} = "y" ]; then
    sudo flatpak install flathub ${flatpak} -y 
    fi
done

# edit auto update settings
sudo sed -i '/upgrade_type/s/default/security/' /etc/dnf/automatic.conf 
sudo sed -i '/apply_updates/s/no/yes/' /etc/dnf/automatic.conf
sudo systemctl enable --now dnf-automatic-install.timer

# Added access to usb ports for current user
sudo usermod -a -G dialout ${USER}

# setup GNOME keyring git credential helper
git config --global credential.helper /usr/libexec/git-core/git-credential-gnome-keyring
git config --global user.email "khoidinhtrinh@gmail.com"
git config --global user.name "khoitd1997"

# increase notification maximum for vscode
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf

# Dev tools installations start here
printf "\n ${cyan}--------DEV-TOOLS----------- ${reset}"
printf "${cyan}\n Basic Install is done, please select additional install options separated by space: \n${reset}"
printf  "${cyan}1/ARM 2/AVR 3/Java 4/Python 5/Doxygen 6/Golang${reset}"
read software_option

# handle options
for option in ${software_option}; do
case $option in 
    1) 
    print_message "Installing ARM\n"
    if ! sudo dnf install $arm_toolchain -y; then
    print_error "Failed to install ARM toolchain\n"
    exit 1
    fi ;;
    2) 
    print_message "Installing AVR\n "
    if ! sudo dnf install $avr_arduino_toolchain -y; then
    print_error "Failed to install AVR toolchain\n"
    exit 1
    fi ;;
    3) 
    sudo dnf install default-jre ;;
    4)
    print_message "Installing Python support"
for pip_software in ${python_pip_package_list}; do
    pip3 install ${pip_software}
done
    ;;
    5)
    print_message "Installing Doxygen support"
    if ! sudo dnf install ${latex_doxygen_toolchain} -y; then
    print_error "Failed to install doxygen toolchain\n"
    exit 1
    fi ;;
    6)
    print_message "Installing Golang support"
    if ! sudo dnf install ${golang_toolchain} -y; then
    print_error "Failed to install Golang toolchain\n"
    exit 1
    fi
    go get -u -v ${golang_package}
    ;;
esac
done 

print_message "Installing vscode, click any key to proceed"
empty_input_buffer()
read input
# got from here: https://code.visualstudio.com/docs/setup/linux
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update
sudo dnf install code -y

print_message "Installing zsh, click any key to proceed"
empty_input_buffer()
read input
sudo dnf install zsh zsh-syntax-highlighting -y
source ../zsh_setup.sh

timedatectl set-local-rtc 1 --adjust-system-clock # adjust clock to local
sudo dnf autoremove -y

#----------------------------------------------------------------------------------------------------
# Post installtion messages start here
exit 0
