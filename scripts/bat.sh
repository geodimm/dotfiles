#!/usr/bin/env bash

set -e

# shellcheck source=../scripts/util.sh
source "$(pwd)/scripts/util.sh"

BAT_VERSION="${BAT_VERSION:=0.20.0}"

do_install() {
	if [[ "$(bat --version 2>/dev/null)" == *"${BAT_VERSION}"* ]]; then
		info "[bat] ${BAT_VERSION} already installed"
		return
	fi

	info "[bat] Install ${BAT_VERSION}"
	local bat=/tmp/bat.deb
	download_to "${bat}" "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb"
	sudo dpkg -i "${bat}"
}

do_configure() {
	info "[bat] Configure"
	info "[bat][configure] Create config file symlink"
	mkdir -p "${XDG_CONFIG_HOME}/bat"
	ln -fs "$(pwd)/bat/config" "${XDG_CONFIG_HOME}/bat/config"
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
