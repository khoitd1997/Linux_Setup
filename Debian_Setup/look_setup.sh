#!/bin/bash

source ../utils.sh

set -e 
set -o pipefail
set -o nounset
wsl="1"
gnome_shell_extensions_list=" clipboard_indicator apt_update_indicator openweather \
extensions_update_notifier dash_to_panel "

#--------------------------------------------------------------------
check_dir OS_Setup/Debian_Setup

# Auxilarry customizations start here
printf "${cyan}\n--------AUXILLARY------------\n ${reset}"


if [ $wsl -eq 1 ]; then
# customizing the shell prompt
sed -i '/force_color_prompt/s/# //' ~/.bashrc # force color prompt, -i for in place manipulations
if [ ! -d ~/Workspace/ ]; then
mkdir ~/Workspace # create workspace dir for Visual Studio Code at home dir
fi

if [ ! -d ~/temp/ ]; then
mkdir ~/temp #  temp dir for basic scratch work
fi

shopt -s nocasematch # ignore case
if [[ "${DESKTOP_SESSION}" == "ubuntu" ]]; then
sudo apt-get install gnome-tweak-tool gnome-shell-extensions chrome-gnome-shell -y

# customize top bar
dconf write /org/gnome/desktop/interface/show-battery-percentage "true"
dconf write /org/gnome/desktop/interface/clock-show-date "true"

# customize gnome terminal
dconf write /org/gnome/terminal/legacy/profiles:/:b8b3c9f0-633d-421b-b899-053a8fdc0d99/use-transparent-background "true"
dconf write /org/gnome/terminal/legacy/profiles:/:b8b3c9f0-633d-421b-b899-053a8fdc0d99/foreground-color "'rgb(211,215,207)'"
dconf write /org/gnome/terminal/legacy/profiles:/:b8b3c9f0-633d-421b-b899-053a8fdc0d99/background-color "'rgb(46,52,54)'"
dconf write /org/gnome/terminal/legacy/profiles:/:b8b3c9f0-633d-421b-b899-053a8fdc0d99/background-transparency-percent "18"
dconf write /org/gnome/terminal/legacy/profiles:/:b8b3c9f0-633d-421b-b899-053a8fdc0d99/cursor-blink-mode "'on'"

# configure background pics
dconf write /org/gnome/desktop/background/color-shading-type "'solid'"
dconf write /org/gnome/desktop/background/picture-options "'zoom'"
dconf write /org/gnome/desktop/background/picture-uri "'file:///usr/share/backgrounds/On_top_of_the_Rubihorn_by_Matthias_Niess.jpg'"
dconf write /org/gnome/desktop/background/primary-color "'#000000'"
dconf write /org/gnome/desktop/background/secondary-color "'#000000'"

# configure file explorer
dconf write /org/gtk/settings/file-chooser/show-hidden "true"

print_message "Please install all the GNOME shell extensions\n"
print_table "${gnome_shell_extensions_list}" 3
sleep 10

empty_input_buffer
print_message "Press anykey when done"
read done_signal

# configure location to be Irvine, CA
dconf write /org/gnome/shell/extensions/openweather/city "'-8.5211767,179.1976747>Vaiaku, Tuvalu>-1 && 33.6856969,-117.8259819>Irvine, Orange County, California, United States of America >-1'"
dconf write /org/gnome/shell/extensions/openweather/city "'33.6856969,-117.8259819>Irvine, Orange County, California, United States of America >-1'"
dconf write /org/gnome/shell/extensions/openweather/show-comment-in-panel "true"
dconf write /org/gnome/shell/extensions/openweather/unit "'celsius'"
dconf write /org/gnome/shell/extensions/openweather/days-forecast "7"
dconf write /org/gnome/shell/extensions/openweather/use-symbolic-icons "false"


# print_message "Which theme do you want? Make sure the PPAs are still legit\n"
# print_message "1\\Obsidian green     2\\Flatabulous with Ultra-Flat theme\n"
# read THEME_CHOICE

# case ${THEME_CHOICE} in
# 1) 
# sudo add-apt-repository ppa:noobslab/themes
# sudo apt-get update
# sudo apt-get install obsidian-gtk-theme
# gsettings set org.gnome.desktop.interface gtk-theme "Obsidian-1-green";;

# 2) 
# sudo add-apt-repository ppa:noobslab/themes
# sudo add-apt-repository ppa:noobslab/icons
# sudo apt-get update
# sudo apt-get install ultra-flat-icons
# sudo apt-get install flatabulous-theme
# gsettings set org.gnome.desktop.interface gtk-theme "Flatabulous"
# gsettings set org.gnome.desktop.interface icon-theme Ultra-Flat;;

# esac

elif [[ "${DESKTOP_SESSION}" == "budgie-desktop" ]]; then
sudo apt-get install gnome-tweak-tool gnome-terminal -y
dconf write /com/solus-project/budgie-panel/panels/{5df1693c-4333-11e8-8a7b-b46d836391f1}/size "16"
dconf write /com/solus-project/budgie-panel/panels/{5df1693c-4333-11e8-8a7b-b46d836391f1}/autohide "'automatic'"
dconf write /net/launchpad/plank/docks/dock1/hide-mode "'auto'"

elif [[ "${DESKTOP_SESSION}" == "plasma" ]]; then 
sudo apt-get install plasma-sdk gnome-terminal -y
# taskbar config
if [ "$HOSTNAME" = "kd-HP" ]; then
cp -vf ~/OS_Setup/plasma/HP_plasma-org.kde.plasma.desktop-appletsrc ~/.config/plasma-org.kde.plasma.desktop-appletsrc
elif [ "$HOSTNAME"= "kd-Asrock" ]; then
cp -vf ~/OS_Setup/plasma/Asrock_plasma-org.kde.plasma.desktop-appletsrc ~/.config/plasma-org.kde.plasma.desktop-appletsrc
fi

# change look and feel
# https://userbase.kde.org/Plasma/Create_a_Look_and_Feel_Package
# https://techbase.kde.org/Development/Tutorials/KWin/Scripting 
# the lookandfeeltool -l list available look and feel packages
mkdir -p ~/.local/share/plasma/look-and-feel/
cp -rf ~/OS_Setup/plasma/Main_Theme_2/ ~/.local/share/plasma/look-and-feel/
lookandfeeltool -a Main_Theme_2
fi

fi # end of look customizations
shopt -u nocasematch

print_message "Auxilarry customizations done\n"