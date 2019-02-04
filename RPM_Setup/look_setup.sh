#!/bin/bash
# look setup for rpm based system

source ../utils.sh

set -e 
set -o pipefail
set -o nounset

gnome_shell_extensions_list=" top_icon_plus extensions_update_notifier workspace_grid Fedora_Linux_Updates_Indicator "

#------------------------------------------------------------------------
if [[ "${DESKTOP_SESSION}" == "gnome" ]]; then
dconf write /org/gnome/desktop/interface/enable-animations "false"

dconf write /org/gnome/settings-daemon/plugins/color/night-light-enabled "true"
dconf write /org/gnome/settings-daemon/peripherals/touchscreen/orientation-lock "true"

sudo dnf install gnome-tweak-tool chrome-gnome-shell gnome-shell-extension-no-topleft-hot-corner -y

dconf write /org/gnome/desktop/interface/clock-show-date "true" 
dconf write /org/gnome/desktop/interface/show-battery-percentage "true"

dconf write /org/gnome/desktop/session/idle-delay "uint32 0"

# customize gnome terminal
dconf reset -f /org/gnome/terminal/
gnome-terminal # launch terminal to make sure a profile folder is created
sleep 4
dconf load /org/gnome/terminal/ < ~/OS_Setup/gnome/gnome_terminal_backup.txt

# configure background pics
dconf write /org/gnome/desktop/background/color-shading-type "'solid'"
dconf write /org/gnome/desktop/background/picture-options "'zoom'"
dconf write /org/gnome/desktop/background/picture-uri "'file:///home/${USER}/OS_Setup/shared/TCP118v1_by_Tiziano_Consonni.jpg'"
dconf write /org/gnome/desktop/background/primary-color "'#000000'"
dconf write /org/gnome/desktop/background/secondary-color "'#000000'"

dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita-dark'"

print_message "Please install all the GNOME shell extensions\n"
print_table "${gnome_shell_extensions_list}" 3

gnome-shell-extension-tool -e 'alternate-tab@gnome-shell-extensions.gcampax.github.com'
gnome-shell-extension-tool -e 'nohotcorner@azuri.free.fr'

print_message "Press anykey when done"
empty_input_buffer
read done_signal

elif [[ "${DESKTOP_SESSION}" == "cinnamon" ]]; then
dconf write /org/cinnamon/desktop/interface/gtk-theme "'Adwaita-dark'"
dconf write /org/cinnamon/desktop/wm/preferences/theme "'Mint-Y-Dark'"
dconf write /org/cinnamon/theme/name "'Mint-Y-Dark'"
dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-display-ac "10800"
dconf write /org/cinnamon/settings-daemon/plugins/power/idle-dim-battery "false"
dconf write /org/cinnamon/cinnamon-session/quit-delay-toggle "true"
dconf write /org/cinnamon/enable-indicators "true"
dconf write /org/cinnamon/sounds/login-enabled "false"
dconf write /org/cinnamon/cinnamon-session/quit-time-delay "20"
dconf write /org/cinnamon/desktop/notifications/remove-old "true"

dconf write /org/cinnamon/enabled-applets "['panel1:right:0:systray@cinnamon.org:0', 'panel1:left:0:menu@cinnamon.org:1', 'panel1:left:1:show-desktop@cinnamon.org:2', 'panel1:left:3:window-list@cinnamon.org:4', 'panel1:right:1:keyboard@cinnamon.org:5', 'panel1:right:2:notifications@cinnamon.org:6', 'panel1:right:3:removable-drives@cinnamon.org:7', 'panel1:right:5:network@cinnamon.org:9', 'panel1:right:6:blueberry@cinnamon.org:10', 'panel1:right:7:power@cinnamon.org:11', 'panel1:right:8:calendar@cinnamon.org:12', 'panel1:right:9:sound@cinnamon.org:13']"

dconf write /org/cinnamon/panels-enabled "['1:0:top']"
fi