#!/bin/sh

DOTFILES_DIR="$HOME/.dotfiles"

if [ -d "$DOTFILES_DIR" ]; then
    log "Dotfiles directory already exists, skipping clone"
else
    log "Setting up dotfiles from mangodots repository..."
    cd "$HOME"
    git clone --separate-git-dir="$DOTFILES_DIR" https://github.com/Gr1shma/mangodots.git tmpdotfiles
    rsync --recursive --exclude '.git' tmpdotfiles/ "$HOME"/
    rm -rf tmpdotfiles

    git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" config status.showUntrackedFiles no
fi

NVIM_CONF_DIR="$HOME/.config/nvim"
if [ -d "$NVIM_CONF_DIR" ]; then
    log "NeoVim config already exists, skipping clone"
else
    log "Setting up NeoVim configuration..."
    git clone --depth=1 https://github.com/Gr1shma/init.lua "$NVIM_CONF_DIR"
fi

PI_DIR="$HOME/.pi"
if [ -d "$PI_DIR" ]; then
    log "pi config already exists, skipping clone"
else
    log "Setting up pi config..."
    git clone --depth=1 https://github.com/Gr1shma/pi.md "$PI_DIR"
fi

log "Dotfiles and configurations set up"
