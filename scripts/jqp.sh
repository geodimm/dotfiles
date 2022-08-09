#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:=${PWD}}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

JQP_VERSION="${JQP_VERSION:=v0.0.3}"

do_install() {
	if [[ "$(jqp -V 2>/dev/null)" == *"${JQP_VERSION}"* ]]; then
		info "[jqp] ${JQP_VERSION} already installed"
		return
	fi

	info "[jqp] Install"
	curl -s "https://raw.githubusercontent.com/georgijd/jqp/${JQP_VERSION}/scripts/install.sh" | bash
}

main() {
	command=$1
	case $command in
	"install")
		shift
		do_install "$@"
		;;
	*)
		error "$(basename "$0"): '$command' is not a valid command"
		;;
	esac
}

main "$@"
