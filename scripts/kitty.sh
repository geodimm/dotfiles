#!/usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

PLATFORM="$(uname | tr '[:upper:]' '[:lower:]')"
DOTFILES_DIR="${DOTFILES_DIR:=${HOME}/dotfiles}"
KITTY_CONFIG_DIR="${XDG_CONFIG_HOME:=${HOME}/.config}/kitty"

function configure_kitty() {
    case "${PLATFORM}" in
    "linux")
        local kitty_path
        kitty_path="$(type -P kitty)"
        sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$kitty_path" 60
        sudo update-alternatives --set x-terminal-emulator "$kitty_path"

        mkdir -p "${HOME}/.local/share/applications/"
        cp "${HOME}"/.local/kitty.app/share/applications/kitty*.desktop "${HOME}/.local/share/applications/"
        sed -i "s|Icon=kitty|Icon=/home/${USER}/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" "${HOME}"/.local/share/applications/kitty*.desktop
        sed -i "s|Exec=kitty|Exec=/home/${USER}/.local/kitty.app/bin/kitty|g" "${HOME}"/.local/share/applications/kitty*.desktop
        ;;

    "darwin")
        sudo ln -fs "/Applications/kitty.app/Contents/MacOS/kitty" "${HOME}/bin/"
        sudo ln -fs "/Applications/kitty.app/Contents/MacOS/kitten" "${HOME}/bin/"
        ;;
    esac

    mkdir -p "${KITTY_CONFIG_DIR}"
    ln -fs "${DOTFILES_DIR}"/kitty/* "${KITTY_CONFIG_DIR}/"

    kitty +kitten themes --config-file-name=themes.conf Catppuccin-Macchiato
}

configure_kitty
