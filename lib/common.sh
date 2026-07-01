#!/bin/sh

log() {
    printf '\033[1;32m[+]\033[0m %s\n' "$1"
}

err() {
    printf '\033[1;31m[-]\033[0m %s\n' "$1" >&2
}

as_root() {
    doas "$@"
}

require_cmd() {
    command -v "$1" >/dev/null 2>&1
}
