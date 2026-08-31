#!/usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

PLATFORM="$(uname | tr '[:upper:]' '[:lower:]')"
DOTFILES_DIR="${DOTFILES_DIR:=${HOME}/dotfiles}"
GHOSTTY_CONFIG_DIR="${XDG_CONFIG_HOME:=${HOME}/.config}/ghostty"

function configure_ghostty() {
    case "${PLATFORM}" in
    "darwin")
        if [[ -x "/Applications/Ghostty.app/Contents/MacOS/ghostty" ]]; then
            mkdir -p "${HOME}/bin"
            ln -fs "/Applications/Ghostty.app/Contents/MacOS/ghostty" "${HOME}/bin/ghostty"
        fi
        ;;
    esac

    ln -fs "${DOTFILES_DIR}"/ghostty "${GHOSTTY_CONFIG_DIR}"
}

configure_ghostty
