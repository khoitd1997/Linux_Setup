#!/bin/bash

source ../utils.sh

set -e 
set -o pipefail
set -o nounset
# set -o xtrace # for debugging only, will print out all commands befor eexecution

not_wsl="1"
gnome_shell_extensions_list=" clipboard_indicator apt_update_indicator openweather \
extensions_update_notifier dash_to_panel system-monitor_by_elvetemedve no_top_left_hot_corner"

# shell extensions in long format for commands
gnome_shell_extensions_long=" alternate-tab@gnome-shell-extensions.gcampax.github.com \
update-extensions@franglais125.gmail.com \
clipboard-indicator@tudmotu.com \
openweather-extension@jenslody.de \
apt-update-indicator@franglais125.gmail.com \
dash-to-panel@jderose9.github.com \
system-monitor@paradoxxx.zero.gmail.com \
nohotcorner@azuri.free.fr"

#--------------------------------------------------------------------
check_dir OS_Setup/Debian_Setup

# Auxilarry customizations start here
printf "${cyan}\n--------AUXILLARY------------\n ${reset}"

if [ $not_wsl -eq 1 ]; then
# customizing the shell prompt
sed -i '/force_color_prompt/s/# //' ~/.bashrc # force color prompt, -i for in place manipulations

# directory setup
mkdir -p ~/Workspace # create workspace dir for Visual Studio Code at home dir
mkdir -p ~/temp #  temp dir for basic scratch work
mkdir -p ~/Additional_Software/bin/ # directory for software that is not installed by package manager
printf "\nPATH=\$PATH:${HOME}/Additional_Software/bin" >> ~/.bashrc # add additional software to search path
source ~/.bashrc

# start desktop evn specific setup
shopt -s nocasematch # ignore case
if [[ "${DESKTOP_SESSION}" == "ubuntu" ]]; then
gsettings set org.gnome.SessionManager logout-prompt false # disable timer countdown for shutdown

dconf write /org/gnome/shell/favorite-apps "@as []" # remove apps from dock/topbar

# configure workspaces
dconf write /org/gnome/mutter/workspaces-only-on-primary "false"

# configure night light
dconf write /org/gnome/settings-daemon/plugins/color/night-light-enabled "true"
dconf write /org/gnome/settings-daemon/plugins/color/night-light-enabled "true"
dconf write /org/gnome/settings-daemon/peripherals/touchscreen/orientation-lock "true"

sudo apt-get install gnome-tweak-tool gnome-shell-extensions chrome-gnome-shell -y

# dependencies for system monitor gnome extensions
sudo apt-get install gir1.2-gtop-2.0 gir1.2-networkmanager-1.0 gir1.2-clutter-1.0

# customize top bar
dconf write /org/gnome/desktop/interface/show-battery-percentage "true"
dconf write /org/gnome/desktop/interface/clock-show-date "true"

# customize power settings
dconf write /org/gnome/desktop/session/idle-delay "uint32 0"

# customize gnome terminal
dconf reset -f /org/gnome/terminal/
gnome-terminal # launch terminal to make sure a profile folder is created
sleep 4
dconf load /org/gnome/terminal/ < ~/OS_Setup/gnome/gnome_terminal_backup.txt

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

# configure theme
dconf write /org/gnome/desktop/interface/gtk-theme "'Ambiance'"

# configure system monitors
dconf write /org/gnome/shell/extensions/system-monitor/memory-graph-width "50"
dconf write /org/gnome/shell/extensions/system-monitor/cpu-graph-width "50"
dconf write /org/gnome/shell/extensions/system-monitor/icon-display "false"
dconf write /org/gnome/shell/extensions/system-monitor/net-display "false"
dconf write /org/gnome/shell/extensions/system-monitor/memory-show-text "false"
dconf write /org/gnome/shell/extensions/system-monitor/cpu-show-text "false"
dconf write /org/gnome/shell/extensions/system-monitor/cpu-style "'both'"
dconf write /org/gnome/shell/extensions/system-monitor/memory-style "'both'"

dconf write /org/gnome/shell/extensions/system-monitor/storage-meter "false"
dconf write /org/gnome/shell/extensions/system-monitor/swap-meter "false"
dconf write /org/gnome/shell/extensions/system-monitor/network-meter "false"
dconf write /org/gnome/shell/extensions/system-monitor/cpu-meter "false"

# configure update monitor
dconf write /org/gnome/shell/extensions/apt-update-indicator/interval-unit "'hours'"
dconf write /org/gnome/shell/extensions/apt-update-indicator/check-interval "5"


# enable extensions
for extension in ${gnome_shell_extensions_long}; do
gnome-shell-extension-tool -e "${extension}" || true
done 

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
elif [ "$HOSTNAME" = "kd-Asrock" ]; then
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

# Add powerline to shell
print_message "Installing powerline shell utils, please confirm its validity, and click any buttons to proceed\n"
empty_input_buffer
read powerline_confirmation
sudo apt-get install fonts-powerline powerline
printf "\n\npowerline-daemon -q\n" >> ~/.bashrc
printf "POWERLINE_BASH_CONTINUATION=1\n" >> ~/.bashrc
printf "POWERLINE_BASH_SELECT=1\n" >> ~/.bashrc
printf ". /usr/share/powerline/bindings/bash/powerline.sh\n" >> ~/.bashrc
sudo cp ~/OS_Setup/terminal/powerline_config.json /usr/share/powerline/config_files/config.json # overwite config file

print_message "Auxilarry customizations done\n"