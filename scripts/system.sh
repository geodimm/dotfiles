#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:=${PWD}}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

function do_install() {
	info "[system] Install packages"
	case "${PLATFORM}" in
	"linux")
		export DEBIAN_FRONTEND=noninteractive
		sudo apt-add-repository -y ppa:git-core/ppa
		sudo apt-add-repository -y ppa:neovim-ppa/unstable
		sudo apt-get update -qq
		# shellcheck disable=2046
		sudo apt-get install -qq -y $(grep -o '^[^#]*' "${HOME}/dotfiles/Aptlist")
		;;
	"darwin")
		brew bundle --file="${HOME}/dotfiles/Brewfile"
		;;
	esac
}

function do_configure() {
	local group fonts_dir
	case "${PLATFORM}" in
	"linux")
		group="${USER}"
		fonts_dir="${HOME}/.fonts"
		;;
	"darwin")
		group="staff"
		fonts_dir="${HOME}/Library/fonts"
		;;
	esac
	info "[system] Configure"
	info "[system][configure] Create directories"
	info "[system][configure][directories] Repositories"
	sudo install -d -m 0755 -o "${USER}" -g "${group}" "${HOME}/repos"

	info "[system][configure][directories] Java workspace"
	install -d -m 0755 -o "${USER}" -g "${group}" "${HOME}/java/workspace"

	info "[system][configure][directories] User Fonts"
	install -d -m 0755 -o "${USER}" -g "${group}" "${fonts_dir}"

	info "[system][configure][directories] User binaries directory"
	install -d -m 0755 -o "${USER}" -g "${group}" "${HOME}/bin"

	# Font: MesloLGS NF
	# https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k
	# https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Meslo/S/Regular/complete
	# Font: Hack Nerd Font
	# https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack/Regular/complete
	info "[system][configure] Install patched fonts"
	local install_dir="/tmp/fonts"
	rm -rf "${install_dir}" && mkdir -p "${install_dir}"

	git clone --quiet "https://github.com/kgraefe/meslo-lgsn-patched" "${install_dir}"/p10k
	(
		cd "${install_dir}"/p10k
		find . -type f -name '*.ttf' ! -exec cp "{}" "${fonts_dir}" \;
	)

	git clone --quiet --filter=blob:none --sparse "https://github.com/ryanoasis/nerd-fonts.git" "${install_dir}"/nerd-fonts
	(
		cd "${install_dir}"/nerd-fonts
		git sparse-checkout add patched-fonts/Meslo/S/Regular
		find . -type f -name '*.ttf' ! -name '*Windows*' ! -name '*Mono*' -exec cp "{}" "${fonts_dir}" \;

		git sparse-checkout add patched-fonts/Hack/Regular
		find . -type f -name '*.ttf' ! -name '*Windows*' ! -name '*Mono*' -exec cp "{}" "${fonts_dir}" \;
	)

	if [[ "${PLATFORM}" == "linux" ]]; then sudo fc-cache -f; fi
}

function main() {
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
