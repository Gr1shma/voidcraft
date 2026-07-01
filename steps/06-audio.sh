#!/bin/sh

log "Enabling Bluetooth service"
if [ -d /etc/sv/bluetoothd ]; then
    as_root ln -sf /etc/sv/bluetoothd /var/service/
else
    err "bluetoothd service not found — is 'bluez' in packages.txt?"
fi

log "Applying audio fixes (ALSA dsp/model config)"
ALSA_CONF="/etc/modprobe.d/alsa-base.conf"
ALSA_LINES='options snd-intel-dspcfg dsp_driver=1
options snd-hda-intel model=alc255-acer-headphone-and-mic'

as_root touch "$ALSA_CONF"

if grep -qF "snd-intel-dspcfg dsp_driver=1" "$ALSA_CONF" 2>/dev/null; then
    log "Audio config already present, skipping"
else
    printf '%s\n' "$ALSA_LINES" | as_root tee -a "$ALSA_CONF" >/dev/null
    log "Audio config written to $ALSA_CONF — reboot required to take effect"
fi
