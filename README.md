<samp>

# Void Linux Post-Installation

Modular post-install setup script for Void Linux.

## Prerequisites

```bash
su -
xbps-install -Sy opendoas
echo "permit nopass :wheel" > /etc/doas.conf
exit

git clone https://github.com/Gr1shma/voidcraft.git
cd voidcraft
```

## Usage

```bash
./install.sh

# for help
./install.sh --help
```

## Steps

| # | Script | Does |
|---|--------|------|
| 0 | `00-network.sh` | Enable dbus/NetworkManager, disable Wi-Fi powersave, configure NM to manage `/etc/resolv.conf` via symlink |
| 1 | `01-dual-boot.sh` |  Detect dual boot, configure os-prober, regenerate GRUB  |
| 2 | `02-packages.sh` | Add non-free/multilib/Blackhole repos, install `packages.txt` |
| 3 | `03-dotfiles.sh` | Clone mangodots + NeoVim config |
| 4 | `04-shell.sh` | Switch to Zsh, symlink `~/.zshrc` |
| 5 | `05-dir.sh` | Create workspace dirs |
| 6 | `06-audio.sh` | Fix the audio issues and setup bluetooth |
| 7 | `07-custom-builds.sh` | Build tools not in xbps |
| 99 | `99-cleanup.sh` | Clean bash configs, xbps cache, old kernels |

## Custom Builds

| Tool | Source |
|------|--------|
| `otter-launcher` | [kuokuo123/otter-launcher](https://github.com/kuokuo123/otter-launcher) |
| `wayfreeze` | [jappie3/wayfreeze](https://github.com/jappie3/wayfreeze) |
| `auto-cpufreq` | [AdnanHodzic/auto-cpufreq](https://github.com/AdnanHodzic/auto-cpufreq), cloned to `/tmp` and installed |
| `Linuwu-Sense` | [0x7375646F/Linuwu-Sense](https://github.com/0x7375646F/Linuwu-Sense), cloned to `~/code` (kept for kernel rebuilds) |
| `zen-browser` | Official tarball install script |


## Structure

```
.
├── install.sh
├── packages.txt
├── not-found.txt
├── new-packages.txt
├── lib/common.sh
└── steps/
    ├── 00-network.sh
    ├── 01-dual-boot.sh
    ├── 02-packages.sh
    ├── 03-dotfiles.sh
    ├── 04-shell.sh
    ├── 05-dir.sh
    ├── 06-audio.sh
    ├── 07-custom-builds.sh
    └── 99-cleanup.sh
```

</samp>
