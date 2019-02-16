#!/bin/bash

source ../utils.sh
set -e 
set -o pipefail
set -o nounset
#---------------------------------------------------------

print_message "Doing post installation setup\n"

sudo timedatectl set-timezone America/Los_Angeles
timedatectl set-local-rtc 1 --adjust-system-clock # adjust clock to local
sudo dnf autoremove -y

synapse&
sleep 7
python3 ../synapse/synapse.py # iffy since synapse's json is unpredictable

# setup launcher shortcut
print_message "Setting up application launcher\n"
printf "\n[redshift]\n allowed=true\n system=false\n users=\n\n" | sudo tee -a /etc/geoclue/geoclue.conf
sudo rm -f /usr/share/applications/flameshot.desktop # remove default flameshot launcher

# xpad stuffs
xpad # launch it to create initial files 
sleep 7
rm -f ~/.config/autostart/xpad.desktop # don't start xpad on startup

python3 launcher_app/add_launcher_app.py

print_message "Post installation setup done\n"