#!/usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

PLATFORM="$(uname | tr '[:upper:]' '[:lower:]')"

function install_fonts() {
    local fonts_dir
    case "${PLATFORM}" in
    "linux")
        group="${USER}"
        fonts_dir="${HOME}/.fonts"
        ;;
    "darwin")
        group="staff"
        fonts_dir="${HOME}/Library/fonts"
        ;;
    esac
    install -d -m 0755 -o "${USER}" -g "${group}" "${fonts_dir}"

    # Font: NerdFontsSymbolsOnly
    # https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/NerdFontsSymbolsOnly
    local install_dir="/tmp/fonts"
    rm -rf "${install_dir}" && mkdir -p "${install_dir}"

    git clone --quiet --filter=blob:none --sparse "https://github.com/ryanoasis/nerd-fonts.git" "${install_dir}"/nerd-fonts
    (
        cd "${install_dir}"/nerd-fonts
        git sparse-checkout add patched-fonts/NerdFontsSymbolsOnly
        find . -type f -name '*.ttf' ! -name '*Propo*' -exec cp "{}" "${fonts_dir}" \;
    )

    if [[ "${PLATFORM}" == "linux" ]]; then
        if ! type -P "fc-cache" >/dev/null; then
            sudo apt update && sudo apt install -y fontconfig
        fi
        sudo fc-cache -f
    fi
}

install_fonts
