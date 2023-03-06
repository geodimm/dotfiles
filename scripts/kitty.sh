#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:=${PWD}}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

KITTY_CONFIG_DIR="${XDG_CONFIG_HOME}/kitty"

function do_install() {
	if [[ "${PLATFORM}" == "darwin" ]]; then
		return
	fi

	if is_installed kitty; then
		info "[kitty] Already installed"
		return
	fi

	info "[kitty] Install"
	curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
	sudo ln -fs "${HOME}/.local/kitty.app/bin/kitty" /usr/local/bin/
	sudo ln -fs "${HOME}/.local/kitty.app/bin/kitten" /usr/local/bin/
}

function do_configure() {
	info "[kitty] Configure"
	case "${PLATFORM}" in
	"linux")
		info "[kitty][configure] Set as default terminal"
		local kitty_path
		kitty_path="$(type -P kitty)"
		sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$kitty_path" 60
		sudo update-alternatives --set x-terminal-emulator "$kitty_path"

		info "[kitty][configure] Configure desktop entries"
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

	info "[kitty][configure] Create config file symlink"
	mkdir -p "${KITTY_CONFIG_DIR}"
	ln -fs "${DOTFILES_DIR}"/kitty/* "${KITTY_CONFIG_DIR}/"

	info "[kitty][configure] Configure the theme"
	kitty +kitten themes --config-file-name=themes.conf Catppuccin-Macchiato
}

function main() {
	command=$1
	case $command in
	"install")
		shift
		do_install "$@"
		;;
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
