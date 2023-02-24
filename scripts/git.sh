#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:=${PWD}}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

function do_configure() {
	info "[git] Configure"
	info "[git][configure] Create config file symlink"
	ln -fs "${DOTFILES_DIR}/git/gitconfig" "${HOME}/.gitconfig"

	info "[git][configure] Create a commit-template file"
	touch "${DOTFILES_DIR}/git/commit-template"
}

function main() {
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
