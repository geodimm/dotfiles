#!/usr/bin/env bash

set -e

# shellcheck source=../scripts/util.sh
source "$(pwd)/scripts/util.sh"

# Font: MesloLGL Nerd Font Mono
# https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Meslo/L/Regular/complete

do_configure() {
	export TERMINAL=gnome-terminal
	local install_dir="/tmp/gogh"

	info "[gnome-terminal] Configure"
	info "[gnome-terminal][configure] Configure themes"
	rm -rf "$install_dir" && mkdir -p "$install_dir"
	git clone https://github.com/Mayccoll/Gogh.git "$install_dir"

	info "[gnome-terminal][configure][themes] One Dark"
	"$install_dir/themes/one-dark.sh"

	info "[gnome-terminal][configure][themes] Nord"
	"$install_dir/themes/nord.sh"

	info "[gnome-terminal][configure][themes] Gruvbox Dark"
	"$install_dir/themes/gruvbox-dark.sh"

	info "[gnome-terminal][configure][themes] Tokyo Night Storm"
	"$install_dir/themes/tokyo-night-storm.sh"

	info "[gnome-terminal][configure][themes] VS Code Dark+"
	"$install_dir/themes/vs-code-dark-plus.sh"
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
