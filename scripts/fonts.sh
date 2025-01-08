#!/usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

PLATFORM="$(uname | tr '[:upper:]' '[:lower:]')"

declare -a FONTS=(
    "Monaspace=https://github.com/githubnext/monaspace.git"
    "JetBrainsMono=https://github.com/JetBrains/JetBrainsMono.git"
)

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

    local install_dir="/tmp/fonts"
    rm -rf "${install_dir}" && mkdir -p "${install_dir}"

    for value in "${FONTS[@]}"; do
        path="${value%%=*}"
        repo="${value##*=}"
        git clone --quiet --filter=blob:none --sparse "${repo}" "${install_dir}/${path}"
        (
            cd "${install_dir}/${path}"
            git sparse-checkout add fonts/variable/
            find . -type f -name '*.ttf' -exec cp "{}" "${fonts_dir}" \;
        )
    done

    if [[ "${PLATFORM}" == "linux" ]]; then
        if ! type -P "fc-cache" >/dev/null; then
            sudo apt update && sudo apt install -y fontconfig
        fi
        sudo fc-cache -f
    fi
}

install_fonts
