#!/usr/bin/env bash

set -e

source "$(pwd)/scripts/util.sh"

do_configure() {
    export TERMINAL=gnome-terminal
    local install_dir="/tmp/gogh"

    info "[gnome-terminal] Configure"
    rm -rf "$install_dir" && mkdir -p "$install_dir"
    git clone https://github.com/Mayccoll/Gogh.git "$install_dir"

    info "[gnome-terminal][configure] Gruvbox Dark"
    "$install_dir/themes/gruvbox-dark.sh"

    info "[gnome-terminal][configure] Gruvbox"
    "$install_dir/themes/gruvbox.sh"

    info "[gnome-terminal][configure] Nord"
    "$install_dir/themes/nord.sh"

    info "[gnome-terminal][configure] One Dark"
    "$install_dir/themes/one-dark.sh"

    info "[gnome-terminal][configure] Srcery"
    "$install_dir/themes/srcery.sh"

    info "[gnome-terminal][configure] Dracula"
    "$install_dir/themes/dracula.sh"
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
