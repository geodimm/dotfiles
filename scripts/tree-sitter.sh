#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:=${PWD}}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

TS_VERSION="${TS_VERSION:=0.20.6}"

do_install() {
	if [[ "$(tree-sitter --version 2>/dev/null)" == *"${TS_VERSION}"* ]]; then
		info "[tree-sitter] ${TS_VERSION} already installed"
		return
	fi

	info "[tree-sitter] Install"
	asset=$(curl --silent "https://api.github.com/repos/tree-sitter/tree-sitter/releases/tags/v${TS_VERSION}" | jq -r '.assets // [] | .[] | select(.name | contains("linux")) | .url')
	if [[ -z $asset ]]; then
		warn "Cannot find a release. Please try again later."
		exit 0
	fi
	local treesitter="${HOME}/bin/tree-sitter"
	download "${asset}" "" | gunzip -c >"${treesitter}"
	chmod +x "${treesitter}"
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
