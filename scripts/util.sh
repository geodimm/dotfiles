#!/usr/bin/env bash

export XDG_CONFIG_HOME="${HOME}/.config"

info() {
	printf "\033[36m%s\033[0m\n" "$*" >&2
}

warn() {
	printf "\033[33mWarning: %s\033[0m\n" "$*" >&2
}

error() {
	printf "\033[31mError: %s\033[0m\n" "$*" >&2
	exit 1
}

is_installed() {
	type -P "$1" >/dev/null 2>&1
}

download_to() {
	local path=$1
	local url=$2
	curl --retry-connrefused --retry 5 --create-dirs -fsLo "${path}" "${url}"
}
