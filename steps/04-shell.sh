#!/bin/sh

if [ "$(basename "$SHELL")" != "zsh" ]; then
    as_root chsh -s /bin/zsh "$USER"
    log "Default shell changed to zsh"
else
    log "zsh is already the default shell"
fi

log "Linking zsh configurations..."
rm -f "$HOME/.zshrc" "$HOME/.zsh_history"
ln -sf "$HOME/.config/zsh/.zshrc" "$HOME/.zshrc"

log "Shell setup complete (shell change takes effect on next login)"
