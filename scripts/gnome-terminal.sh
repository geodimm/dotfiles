#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:=${PWD}}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

# Font: MesloLGL Nerd Font Mono
# https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Meslo/L/Regular/complete

do_configure() {
	export TERMINAL=gnome-terminal
	local install_dir="/tmp/gogh"

	info "[gnome-terminal] Configure"
	info "[gnome-terminal][configure] Configure themes"
	rm -rf "$install_dir" && mkdir -p "$install_dir"
	git clone --quiet https://github.com/Mayccoll/Gogh.git "$install_dir"

	info "[gnome-terminal][configure][themes] Tokyo Night Storm"
	"$install_dir/themes/tokyo-night-storm.sh"
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
