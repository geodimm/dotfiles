#!/usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

PLATFORM="$(uname | tr '[:upper:]' '[:lower:]')"
DOTFILES_DIR="${DOTFILES_DIR:=${HOME}/dotfiles}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=${HOME}/.config}"

function do_configure() {
    case "${PLATFORM}" in
    "darwin")
        if [[ -x "/Applications/Ghostty.app/Contents/MacOS/ghostty" ]]; then
            mkdir -p "${HOME}/bin"
            ln -fs "/Applications/Ghostty.app/Contents/MacOS/ghostty" "${HOME}/bin/ghostty"
        fi
        ;;
    esac

    rm -rf "${XDG_CONFIG_HOME}/ghostty" && mkdir -p "${XDG_CONFIG_HOME}"
    ln -fs "${DOTFILES_DIR}/ghostty" "${XDG_CONFIG_HOME}/"
}

function main() {
    command=$1
    case $command in
    "configure")
        shift
        do_configure "$@"
        ;;
    *)
        echo "$(basename "$0"): '$command' is not a valid command"
        ;;
    esac
}

main "$@"
