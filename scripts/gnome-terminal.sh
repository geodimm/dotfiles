#!/usr/bin/env bash

set -e

source "$(pwd)/scripts/util.sh"

TERMINAL=gnome-terminal

do_configure() {
    info "[gnome-terminal] Configure"
    local installer="/tmp/gogh.sh"
    download_to "${installer}" https://raw.githubusercontent.com/Mayccoll/Gogh/master/gogh.sh
    chmod +x "${installer}"
    # "Gruvbox Dark" "Gruvbox" "Nord" "One Dark"
    echo "61 62 115 122" | TERMINAL="${TERMINAL}" bash -c "${installer}"
}

main() {
    command=$1
    case $command in
        "configure")
            shift
            do_configure "$@"
            ;;
        *)
            error "$(basename "$0"): '$command' is not a valid command"
            ;;
    esac
}

main "$@"
