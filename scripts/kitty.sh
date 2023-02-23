#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:=${PWD}}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

KITTY_CONFIG_DIR="${XDG_CONFIG_HOME}/kitty"

do_install() {
	if is_installed kitty; then
		info "[kitty] Already installed"
		return
	fi

	info "[kitty] Install"
	curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
	sudo ln -s "${HOME}/.local/kitty.app/bin/kitty" /usr/local/bin/
	sudo ln -s "${HOME}/.local/kitty.app/bin/kitten" /usr/local/bin/
}

do_configure() {
	info "[kitty] Configure"
	info "[kitty][configure] Set as default terminal"
	local kitty_path
	kitty_path="$(type -P kitty)"
	sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$kitty_path" 60
	sudo update-alternatives --set x-terminal-emulator "$kitty_path"

	info "[kitty][configure] Configure desktop entries"
	mkdir -p "${HOME}/.local/share/applications/"
	cp "${HOME}"/.local/kitty.app/share/applications/kitty.desktop "${HOME}/.local/share/applications/"
	sed -i "s|Icon=kitty|Icon=/home/${USER}/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" "${HOME}"/.local/share/applications/kitty.desktop
	sed -i "s|Exec=kitty|Exec=/home/${USER}/.local/kitty.app/bin/kitty|g" "${HOME}"/.local/share/applications/kitty.desktop

	info "[kitty][configure] Create config file symlink"
	mkdir -p "${KITTY_CONFIG_DIR}"
	ln -fs "${DOTFILES_DIR}/kitty/kitty.conf" "${KITTY_CONFIG_DIR}/kitty.conf"
	ln -fs "${DOTFILES_DIR}/kitty/zoom_toggle.py" "${KITTY_CONFIG_DIR}/zoom_toggle.py"

	info "[kitty][configure] Configure the theme"
	kitty +kitten themes --config-file-name=themes.conf Catppuccin-Macchiato
}

main() {
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
