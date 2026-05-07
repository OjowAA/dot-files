#!/bin/bash

mkdir -p ~/.config
cp -r ./dot-files/.config/. ~/.config/
ln -sf ./dot-files/.bash_aliases ~/.bash_aliases

ln -sf ./dot-files/.zshrc ~/.zshrc
ln -sf ./dot-files/.bashrc ~/.bashrc
