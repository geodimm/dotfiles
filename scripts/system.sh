#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:=${PWD}}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

FONTS_DIR="$HOME/.local/share/fonts"

do_install() {
	local packages=(
		build-essential
		cmake
		curl
		dconf-cli
		fd-find
		fontconfig
		git
		htop
		httpie
		jq
		libreadline-dev
		moreutils
		ncurses-term
		neovim
		python3-dev
		python3-pip
		ripgrep
		shellcheck
		tig
		tree
		units
		universal-ctags
		unrar
		unzip
		uuid-runtime
		wget
		xclip
		zsh
	)

	info "[system] Install packages"
	export DEBIAN_FRONTEND=noninteractive
	sudo apt-add-repository -y ppa:git-core/ppa
	sudo apt-add-repository -y ppa:neovim-ppa/stable
	sudo apt-get update -qq
	sudo apt-get install -qq -y "${packages[@]}"
}

do_configure() {
	info "[system] Configure"
	info "[system][configure] Create directories"
	info "[system][configure][directories] Repositories"
	sudo install -d -m 0755 -o "${USER}" -g "${USER}" /repos

	info "[system][configure][directories] Java workspace"
	install -d -m 0755 -o "${USER}" -g "${USER}" "$HOME/java/workspace"

	info "[system][configure][directories] User Fonts"
	install -d -m 0755 -o "${USER}" -g "${USER}" "${FONTS_DIR}"

	info "[system][configure][directories] User binaries directory"
	install -d -m 0755 -o "${USER}" -g "${USER}" "$HOME/bin"

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
		find . -type f -name '*.ttf' ! -exec cp "{}" "${FONTS_DIR}" \;
	)

	git clone --quiet --filter=blob:none --sparse "https://github.com/ryanoasis/nerd-fonts.git" "${install_dir}"/nerd-fonts
	(
		cd "${install_dir}"/nerd-fonts
		git sparse-checkout add patched-fonts/Meslo/S/Regular
		find . -type f -name '*.ttf' ! -name '*Windows*' ! -name '*Mono*' -exec cp "{}" "${FONTS_DIR}" \;

		git sparse-checkout add patched-fonts/Hack/Regular
		find . -type f -name '*.ttf' ! -name '*Windows*' ! -name '*Mono*' -exec cp "{}" "${FONTS_DIR}" \;
	)
	sudo fc-cache -f
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
