#!/bin/sh
set -e
cd "$(dirname "$0")"
. ./lib/common.sh

STEPS_DIR="steps"

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS] [STEP...]

Run all post-install steps, or only the ones you choose.

OPTIONS:
  -h, --help        Show this help message
  -l, --list        List available steps and exit
  -f, --from STEP   Run from STEP onward (inclusive)

STEP:
  Can be given as the number prefix (e.g. "03"), with or without
  leading zero, or the full filename (e.g. "03-shell.sh").

EXAMPLES:
  $(basename "$0")                  # run all steps
  $(basename "$0") 01 04            # run only steps 01 and 04
  $(basename "$0") 03-shell.sh      # run only step 03
  $(basename "$0") --from 03        # run step 03 and everything after
  $(basename "$0") --list           # show available steps
EOF
}

list_steps() {
    for step in "$STEPS_DIR"/*.sh; do
        printf '%s\n' "$(basename "$step")"
    done
}

resolve_step() {
    token="$1"
    if [ -f "$STEPS_DIR/$token" ]; then
        printf '%s\n' "$STEPS_DIR/$token"
        return 0
    fi
    num=$(printf '%02d' "$token" 2>/dev/null) || num="$token"
    match=$(find "$STEPS_DIR" -maxdepth 1 -name "${num}-*.sh" | head -n1)
    if [ -n "$match" ]; then
        printf '%s\n' "$match"
        return 0
    fi
    return 1
}

run_step() {
    step="$1"
    log "Running $(basename "$step")"
    . "$step" || {
        err "$step failed"
        exit 1
    }
}

FROM_STEP=""
STEPS_TO_RUN=""

while [ $# -gt 0 ]; do
    case "$1" in
    -h | --help)
        usage
        exit 0
        ;;
    -l | --list)
        list_steps
        exit 0
        ;;
    -f | --from)
        [ -n "$2" ] || {
            err "--from requires a STEP argument"
            exit 1
        }
        FROM_STEP="$2"
        shift 2
        ;;
    --from=*)
        FROM_STEP="${1#--from=}"
        shift
        ;;
    -*)
        err "Unknown option: $1"
        usage
        exit 1
        ;;
    *)
        STEPS_TO_RUN="$STEPS_TO_RUN $1"
        shift
        ;;
    esac
done

log "Starting Void Linux post-install"

if [ -n "$FROM_STEP" ]; then
    start_file=$(resolve_step "$FROM_STEP") || {
        err "No step matches '$FROM_STEP'"
        exit 1
    }
    started=0
    for step in "$STEPS_DIR"/*.sh; do
        if [ "$step" = "$start_file" ]; then
            started=1
        fi
        [ "$started" -eq 1 ] && run_step "$step"
    done

elif [ -n "$STEPS_TO_RUN" ]; then
    for token in $STEPS_TO_RUN; do
        step=$(resolve_step "$token") || {
            err "No step matches '$token'"
            exit 1
        }
        run_step "$step"
    done

else
    for step in "$STEPS_DIR"/*.sh; do
        run_step "$step"
    done
fi

log "Post-install complete"
