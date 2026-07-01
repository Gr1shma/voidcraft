#!/bin/sh

is_dual_booted() {
    printf "Are you dual booting? (y/N): "
    read -r answer
    case "$answer" in
    y | Y | yes | YES) return 0 ;;
    *) return 1 ;;
    esac
}

if ! is_dual_booted; then
    log "Skipping dual boot configuration"
    return 0
fi

log "Setting up dual boot..."

if ! xbps-query os-prober >/dev/null 2>&1; then
    log "Installing os-prober..."
    as_root xbps-install -Sy os-prober
fi

GRUB_CONF="/etc/default/grub"

if grep -qF "GRUB_DISABLE_OS_PROBER=false" "$GRUB_CONF" 2>/dev/null; then
    log "os-prober already enabled in GRUB config, skipping"
else
    as_root sed -i '/GRUB_DISABLE_OS_PROBER/d' "$GRUB_CONF"
    printf 'GRUB_DISABLE_OS_PROBER=false\n' | as_root tee -a "$GRUB_CONF" >/dev/null
    log "Enabled os-prober in $GRUB_CONF"
fi

log "Detecting other operating systems..."
as_root os-prober

log "Regenerating GRUB config..."
as_root update-grub

log "Dual boot setup complete — reboot to verify GRUB menu"
