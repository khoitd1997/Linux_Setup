#!/bin/bash

source ../utils.sh

set -e 
set -o pipefail
set -o nounset

gnome_shell_extensions_list=" extensions_update_notifier workspace_grid Fedora_Linux_Updates_Indicator "

#------------------------------------------------------------------------
if [[ "${DESKTOP_SESSION}" == "gnome" ]]; then
dconf write /org/gnome/desktop/interface/enable-animations "false"

dconf write /org/gnome/settings-daemon/plugins/color/night-light-enabled "true"
dconf write /org/gnome/settings-daemon/peripherals/touchscreen/orientation-lock "true"

sudo dnf install gnome-tweak-tool chrome-gnome-shell -y

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

empty_input_buffer
print_message "Press anykey when done"
read done_signal

fi