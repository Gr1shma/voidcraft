#!/bin/sh

log "Configuring extra repositories (non-free, multilib, blackhole mirror)..."

as_root xbps-install -Sy void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree

log "Adding Blackhole mirror..."
as_root cp /usr/share/xbps.d/00-repository-main.conf /etc/xbps.d/
as_root sed -i "1i repository=https://mirror.black-hole.dev/\$(xbps-uhelper arch)" /etc/xbps.d/00-repository-main.conf

as_root xbps-install -S

log "Installing required packages from packages.txt..."

PKGS=$(grep -v '^#' packages.txt | grep -v '^$')

if [ -n "$PKGS" ]; then
    as_root xbps-install -y $PKGS
else
    log "No packages found to install."
fi

log "Packages installed"
