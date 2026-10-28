#!/bin/sh

log "Configuring extra repositories (non-free, multilib, blackhole mirror)..."

as_root xbps-install -Sy void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree

log "Installing required packages from packages.txt..."

PKGS=$(grep -v '^#' packages.txt | grep -v '^$')

if [ -n "$PKGS" ]; then
    as_root xbps-install -y $PKGS
else
    log "No packages found to install."
fi

log "Packages installed"
