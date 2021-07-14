#!/usr/bin/env bash

set -e

# shellcheck source=../scripts/util.sh
source "$(pwd)/scripts/util.sh"

RVM_DIR="${HOME}/.rvm"
RUBY_VERSION=2.6

do_install() {
	# shellcheck source=../../.rvm/scripts/rvm
	source "${RVM_DIR}/scripts/rvm"
	if [[ "$(rvm list | grep ${RUBY_VERSION})" != "" ]]; then
		info "[ruby] ${RUBY_VERSION} already installed"
		return
	fi

	info "[ruby] Install ${RUBY_VERSION}"
	rvm install "${RUBY_VERSION}"
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
