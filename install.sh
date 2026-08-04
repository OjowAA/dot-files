#!/usr/bin/env bash

set -euo pipefail

# Resolve the directory this script lives in
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Find the repository root
if ! REPO_DIR="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null)"; then
    echo "Error: This script must be run from inside a Git repository."
    exit 1
fi

# Ensure we're in the expected repository
if [[ "$(basename "$REPO_DIR")" != "dotfiles" ]]; then
    echo "Error: Expected repository 'dotfiles', found '$(basename "$REPO_DIR")'."
    exit 1
fi

# Copy config contents and link
mkdir -p "$HOME/.config"
cp -a "$REPO_DIR/config/." "$HOME/.config/"
cp -a "$REPO_DIR/homerc/.bash_aliases" "$HOME/.bash_aliases"
cp -a "$REPO_DIR/homerc/.vimrc" "$HOME/.vimrc"

for file in .bashrc .zshrc; do
    if [[ -e "$HOME/$file" ]]; then
        read -rp "$file already exists. Overwrite? [y/N] " reply
        if [[ "$reply" =~ ^[Yy]$ ]]; then
            cp -a "$REPO_DIR/homerc/$file" "$HOME/$file"
            echo "Copied $file"
        else
            echo "Skipped $file"
        fi
    else
        cp -a "$REPO_DIR/homerc/$file" "$HOME/$file"
        echo "Copied $file"
    fi
done

echo "Dotfiles installed from: $REPO_DIR"
