#!/bin/sh

as_root xbps-install -Sy dbus NetworkManager
as_root ln -sf /etc/sv/dbus /var/service/
as_root ln -sf /etc/sv/NetworkManager /var/service/

as_root ln -sf /usr/bin/true /etc/runit/core-services/03-network.sh 2>/dev/null || true

log "Waiting for NetworkManager service to start..."
for i in $(seq 1 10); do
    if require_cmd nmcli && nmcli general status >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

as_root mkdir -p /etc/NetworkManager/conf.d
printf "[connection]\nwifi.powersave = 2\n" | as_root tee /etc/NetworkManager/conf.d/disable-powersave.conf >/dev/null

if require_cmd nmcli; then
    nmcli radio wifi on
    as_root nmcli connection modify --all 802-11-wireless.powersave 2 2>/dev/null || true
fi

log "Network configured, powersave disabled persistently"

log "Configuring NetworkManager to manage /etc/resolv.conf..."
as_root mkdir -p /etc/NetworkManager/conf.d
printf "[main]\ndns=default\nrc-manager=symlink\n" | as_root tee /etc/NetworkManager/conf.d/dns.conf >/dev/null

as_root sv restart NetworkManager
sleep 3

as_root ln -sf /run/NetworkManager/resolv.conf /etc/resolv.conf

if [ -L /etc/resolv.conf ]; then
    log "resolv.conf is now a symlink managed by NetworkManager"
else
    log "WARNING: /etc/resolv.conf is not a symlink — DNS config may need manual check"
fi
