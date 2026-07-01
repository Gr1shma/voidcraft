#!/bin/sh

log "Cleaning up system files..."

rm -f "$HOME/.bash_history" \
    "$HOME/.bash_logout" \
    "$HOME/.bash_profile" \
    "$HOME/.bashrc" \
    "$HOME/.lesshst"

log "Running package manager cache cleanups..."
as_root xbps-remove -Ooy

if command -v vkpurge >/dev/null 2>&1; then
    as_root vkpurge rm all 2>/dev/null || true
fi

log "Cleanup completed successfully"
