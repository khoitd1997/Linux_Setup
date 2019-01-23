#!/bin/bash
# scripts written to quickly install scoop programs on windows
# for archival purpose right now since wsl is better

# command line oritented tools like fzf or ls
scoop_normal=" fzf ag "

# extra are things that don't fit traditional scoop and is in separate repos
scoop_extra=" hyper "

#----------------------------------------------------------------------------------------------------

scoop bucket add extras

scoop_install ${scoop_normal} ${scoop_extra}

scoop update # update just scoop
scoop update * # update all apps