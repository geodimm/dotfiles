#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:=${PWD}}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

NVM_DIR="${HOME}/.nvm"
NVM_VERSION="${NVM_VERSION:=v0.39.2}"

do_install() {
	if [[ -f "${NVM_DIR}/nvm.sh" ]]; then
		info "[nvm] Already installed. Updating..."
		(
			cd "${NVM_DIR}"
			git fetch origin tag "${NVM_VERSION}" --depth 1 --quiet
			git -c advice.detachedHead=false checkout -f --quiet FETCH_HEAD
		)
		return
	fi

	info "[nvm] Install ${NVM_VERSION}"
	mkdir -p "${NVM_DIR}"
	curl --silent -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
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
