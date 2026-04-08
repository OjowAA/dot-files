#!/bin/bash

mkdir -p ~/.config
cp -r .config/. ~/.config/
cp .bash_aliases ~/
cp .bashrc ~/
# ln -s ~/dot-files/.config/tmux/ ~/.config/tmux
