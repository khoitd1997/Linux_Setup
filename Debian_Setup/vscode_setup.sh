#!/bin/bash
# scripts written to quickly install visual studio code extensions

#----------------------------------------------------------------------------------------------------
# essential extensions that will always be installed
extension_general="ms-vscode.cpptools  kevinkyang.auto-comment-blocks CoenraadS.bracket-pair-colorizer formulahendry.code-runner \
eamodio.gitlens donjayamanne.githistory huizhou.githd PKief.material-icon-theme webfreak.debug  \
wayou.vscode-todo-highlight emilast.logfilehighlighter "

extension_theme=" zhuangtongfa.material-theme "

extension_dropped=" vsciot-vscode.vscode-arduino"

# specialized dev tools
extension_python=" ms-python.python"
extension_java=" redhat.java vscjava.vscode-java-debug naco-siren.gradle-language "
extension_doxygen=" bbenoist.doxygen cschlosser.doxdocgen "
extension_arm=" dan-c-underwood.arm "
extension_vhdl=" puorc.awesome-vhdl "
extension_md=" mushan.vscode-paste-image DavidAnson.vscode-markdownlint yzhang.markdown-all-in-one \
hnw.vscode-auto-open-markdown-preview shd101wyy.markdown-preview-enhanced "
extension_web=" formulahendry.auto-close-tag "

source ../utils.sh

set -e 
set -o pipefail
set -o nounset

#----------------------------------------------------------------------------------------------------
if ! dpkg-query -l code; then
print_error "Visual Studio Code not installed\n"
 exit 1
 else
print_message "Visual Studio Code found\n "
 fi

extension_all="${extension_general}${extension_theme}"
clear
print_message "Please input the number of chosen options separated by space\n"
print_message "1/Python\n"
print_message "2/Doxygen\n"
print_message "3/ARM MCU\n"
print_message "4/VHDL\n"
print_message "5/Java, Gradle\n"
print_message "6/Mark Down\n"
print_message "7/Html, typescript, javascript\n"
read input
for var in ${input}
do
    case $var in
    1)extension_all="${extension_all}${extension_python}";;
    2)extension_all="${extension_all}${extension_doxygen}";;
    3)extension_all="${extension_all}${extension_arm}";;
    4)extension_all="${extension_all}${extension_vhdl}";;
    5)extension_all="${extension_all}${extension_java}";;
    6)extension_all="${extension_all}${extension_md}";;
    7)extension_all="${extension_all}${extension_web}";;
    *) ;;
esac
done

print_message "Starting Package Installation\n"
for ext in ${extension_all}
do
if ! code --install-extension "${ext}" ; then
print_error "Errrors while installing extensions\n"
exit 1
fi
done

print_message "Installation Done\n"
code --list-extensions

# copy Visual Studdio Code setting file and keybinding file
cp -f ~/Linux_Setup/Debian_Setup/VisualCode/settings.json ~/.config/Code/User/settings.json
cp -f ~/Linux_Setup/Debian_Setup/VisualCode/keybindings.json ~/.config/Code/User/keybindings.json

print_message "Visual Studio Code Configurations done\n"
exit 0
