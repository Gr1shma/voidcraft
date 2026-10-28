#!/bin/sh

INSTALL_DIR="/tmp/void-custom-builds"
mkdir -p "$INSTALL_DIR"

# Rust toolchain
log "Installing Rust toolchain..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --quiet -y
. "$HOME/.local/share/cargo/env"

# iji (bootstrap: installs itself)
log "Installing iji..."
git clone https://github.com/Gr1shma/iji "$INSTALL_DIR/iji"
cd "$INSTALL_DIR/iji"
cargo run --release -- i https://github.com/Gr1shma/iji
cd "$HOME"

command -v iji >/dev/null || {
    log "iji not on PATH, add its install dir to PATH first"
    exit 1
}

log "Installing via iji..."
iji i https://github.com/Gr1shma/grc
iji i https://github.com/kuokuo123/otter-launcher
iji i https://github.com/Mjoyufull/fsel
iji i https://github.com/jappie3/wayfreeze
iji i https://github.com/chrishrb/go-grip
iji i https://github.com/mangowm/mangobar
iji i https://github.com/2besita/nock

# auto-cpufreq
log "Installing auto-cpufreq..."
ACPUFREQ_DIR="$INSTALL_DIR/auto-cpufreq"
git clone https://github.com/AdnanHodzic/auto-cpufreq "$ACPUFREQ_DIR"
if [ -f "$ACPUFREQ_DIR/auto-cpufreq-installer" ]; then
    printf 'i\n' | as_root "$ACPUFREQ_DIR/auto-cpufreq-installer"
else
    log "auto-cpufreq-installer not found at $ACPUFREQ_DIR, skipping"
fi
cd "$HOME"

# Zen Browser
log "Installing Zen Browser..."
curl -fsSL https://github.com/zen-browser/updates-server/raw/refs/heads/main/install.sh | $SHELL

# JetBrains font
mkdir -p ~/.local/share/fonts
curl -L https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip -o /tmp/jbm.zip
unzip /tmp/jbm.zip "fonts/ttf/*.ttf" -d ~/.local/share/fonts/
fc-cache -f

# Cleanup build artifacts
rm -rf "$INSTALL_DIR"
log "Custom builds done"
