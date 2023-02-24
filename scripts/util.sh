#!/usr/bin/env bash

# shellcheck disable=2034
XDG_CONFIG_HOME="${HOME}/.config"

function info() {
	printf "\033[36m%s\033[0m\n" "$*" >&2
}

function warn() {
	printf "\033[33mWarning: %s\033[0m\n" "$*" >&2
}

function error() {
	printf "\033[31mError: %s\033[0m\n" "$*" >&2
	exit 1
}

function is_installed() {
	type -P "$1" >/dev/null 2>&1
}

function download() {
	local src=$1
	local dest=$2
	local opts=(--silent --fail --retry-connrefused --retry 5 --location -H "Accept: application/octet-stream")
	if [ -n "${dest}" ]; then
		opts+=(--create-dirs --output "${dest}")
	fi
	curl "${opts[@]}" "${src}"
}
