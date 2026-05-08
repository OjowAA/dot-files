#!/bin/bash

REPO_DIR="$(pwd)"

mkdir -p "$HOME/.config"

cp -r "$REPO_DIR/.config" "$HOME/.config"

ln -sf "$REPO_DIR/.bash_aliases" "$HOME/.bash_aliases"
ln -sf "$REPO_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$REPO_DIR/.bashrc" "$HOME/.bashrc"
echo "[!] Updated dotfiles in $HOME"
