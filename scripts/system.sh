#!/usr/bin/env bash

set -e

# shellcheck source=../scripts/util.sh
source "$(pwd)/scripts/util.sh"

FONTS_DIR="$HOME/.local/share/fonts"

do_configure() {
	info "[system] Create /repos directory"
	sudo install -d -m 0755 -o "${USER}" -g "${USER}" /repos

	info "[system] Create Java workspace directory"
	install -d -m 0755 -o "${USER}" -g "${USER}" "$HOME/workspace"

	# Font: MesloLGL Nerd Font Mono
	# https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Meslo/L/Regular/complete
	info "[system] Install patched fonts"
	local install_dir="/tmp/nerd-fonts"
	rm -rf "$install_dir" && mkdir -p "$install_dir"
	git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git "$install_dir"
	cd "$install_dir"
	git sparse-checkout add patched-fonts/Meslo/L/Regular
	find . -type f -name '*.ttf' ! -name '*Windows*' -exec cp "{}" "$FONTS_DIR" \;
	sudo fc-cache -f -v
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
