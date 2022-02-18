#!/usr/bin/env bash

set -e

# shellcheck source=../scripts/util.sh
source "$(pwd)/scripts/util.sh"

RVM_DIR="${HOME}/.rvm"

do_install() {
	if is_installed colorls; then
		info "[colorls] Already installed. Updating..."
		# shellcheck source=../../.rvm/scripts/rvm
		source "${RVM_DIR}/scripts/rvm" && gem update colorls
		return
	fi

	info "[colorls] Install"
	# shellcheck source=../../.rvm/scripts/rvm
	source "${RVM_DIR}/scripts/rvm" && gem install colorls
}

do_configure() {
	info "[colorls] Configure"
	info "[colorls][configure] Create symlinks"
	mkdir -p "${XDG_CONFIG_HOME}/colorls"
	ln -fs "$(pwd)/colorls/dark_colors.yaml" "${XDG_CONFIG_HOME}/colorls/dark_colors.yaml"
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
