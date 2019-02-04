#!/bin/bash
# used to setting up tmux keybindings and stuffs based on vim

# vim-like pane switching
# alt + vim_key for switching
tmux bind-key -n M-k select-pane -U 
tmux bind-key -n M-j select-pane -D 
tmux bind-key -n M-h select-pane -L 
tmux bind-key -n M-l select-pane -R 

# unbind default keys
tmux unbind Up     
tmux unbind Down   
tmux unbind Left   
tmux unbind Right  

tmux unbind C-Up   
tmux unbind C-Down 
tmux unbind C-Left 
tmux unbind C-Right

# use v for vert and h for hor switching
# still need prefix
tmux bind-key h split-window -h
tmux bind-key v split-window -v
tmux unbind '"'
tmux unbind %

# ctrl a for prefix
tmux unbind C-b
tmux set-option -g prefix C-a
tmux bind-key C-a send-prefix

tmux unbind x
tmux bind-key x kill-pane

# mouse mode
tmux set -g mouse on