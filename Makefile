XDG_CONFIG_HOME ?= $(HOME)/.config

deps:
	sudo apt install -y\
		zsh \
		curl \
		tmux \
		i3 \
		py3status \
		scrot \
		neovim \
		tig \
		httpie \
		htop \
		jq

.PHONY: tmux
tmux:
	ln -fs `pwd`/tmux/tmux.conf $(HOME)/.tmux.conf
	ln -fs `pwd`/tmux/tnew.sh $(HOME)/tnew.sh

.PHONY: i3
i3:
	mkdir -p $(XDG_CONFIG_HOME)/i3
	ln -fs `pwd`/i3/config $(XDG_CONFIG_HOME)/i3/config
	ln -fs `pwd`/i3/status.conf $(HOME)/.i3status.conf

.PHONY: zsh
zsh:
	ln -fs `pwd`/zsh/zshrc ~/.zshrc

.PHONY: git
git:
	ln -fs `pwd`/git/gitconfig $(HOME)/.gitconfig

.PHONY: vim
vim:
	rm -f ~/.vim
	ln -fs `pwd`/vim ~/.vim
	ln -fs `pwd`/vim/vimrc ~/.vimrc

.PHONY: neovim
neovim:
	rm -rf $(XDG_CONFIG_HOME)/nvim
	ln -fs `pwd`/vim $(XDG_CONFIG_HOME)/nvim
	ln -fs $(XDG_CONFIG_HOME)/nvim/vimrc $(XDG_CONFIG_HOME)/nvim/init.vim
	curl -fLo `pwd`/vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	nvim +PlugInstall +qall

.PHONY: misc
misc:
	ln -fs `pwd`/tigrc $(HOME)/.tigrc
	mkdir -p $(HOME)/.ssh/tmp
