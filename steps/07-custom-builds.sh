#!/bin/sh

INSTALL_DIR="/tmp/void-custom-builds"
mkdir -p "$INSTALL_DIR"

# Rust toolchain
log "Installing Rust toolchain..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --quiet -y
. "$HOME/.local/share/cargo/env"

# grc
log "Installing grc..."
git clone https://github.com/Gr1shma/grc "$INSTALL_DIR/grc"
cd "$INSTALL_DIR/grc"
cargo install --path .
cd "$HOME"

# otter-launcher
log "Building otter-launcher..."
git clone https://github.com/kuokuo123/otter-launcher "$INSTALL_DIR/otter-launcher"
cd "$INSTALL_DIR/otter-launcher"
cargo build --release
mkdir -p "$HOME/.config/otter-launcher"
cp config_example/config.toml "$HOME/.config/otter-launcher/config.toml"
as_root cp target/release/otter-launcher /usr/bin/otter-launcher
cd "$HOME"

# wayfreeze
log "Building wayfreeze..."
git clone https://github.com/jappie3/wayfreeze "$INSTALL_DIR/wayfreeze"
cd "$INSTALL_DIR/wayfreeze"
cargo build --release
as_root cp target/release/wayfreeze /usr/bin/wayfreeze
cd "$HOME"

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

# Linuwu-Sense kernel module
log "Installing Linuwu-Sense kernel module..."
LINUWU_DIR="$HOME/code/Linuwu-Sense"
mkdir -p "$HOME/code"
if [ ! -d "$LINUWU_DIR" ]; then
    git clone https://github.com/0x7375646F/Linuwu-Sense "$LINUWU_DIR"
fi
if [ -d "$LINUWU_DIR" ]; then
    cd "$LINUWU_DIR"
    as_root make install
    cd "$HOME"

    # Deploy the runit service + shutdown hook from dotfiles config
    LINUWU_CONF="$HOME/.config/linuwu-sense"
    if [ -f "$LINUWU_CONF/install.sh" ]; then
        log "Setting up Linuwu-Sense runit service..."
        as_root sh "$LINUWU_CONF/install.sh"
    fi
else
    log "Linuwu-Sense source not found at $LINUWU_DIR, skipping"
fi

# Zen Browser
log "Installing Zen Browser..."
curl -fsSL https://github.com/zen-browser/updates-server/raw/refs/heads/main/install.sh | $SHELL

# pi coding agent
log "Installing pi coding agent..."
as_root npm install -g --ignore-scripts @earendil-works/pi-coding-agent

# go-grip
log "Installing go-grip..."
go install github.com/chrishrb/go-grip@latest

# JetBrains font
mkdir -p ~/.local/share/fonts
curl -L https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip -o /tmp/jbm.zip
unzip /tmp/jbm.zip "fonts/ttf/*.ttf" -d ~/.local/share/fonts/
fc-cache -f

# Cleanup build artifacts
rm -rf "$INSTALL_DIR"
log "Custom builds done"
