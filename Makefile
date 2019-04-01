XDG_CONFIG_HOME ?= $(HOME)/.config

deps:
	sudo apt install -y\
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

tmux:
	ln -fs `pwd`/tmux/tmux.conf $(HOME)/.tmux.conf
	ln -fs `pwd`/tmux/tnew.sh $(HOME)/tnew.sh

i3:
	mkdir -p ~/.config/i3/
	ln -fs `pwd`/i3/config $(XDG_CONFIG_HOME)/i3/config
	ln -fs `pwd`/i3/status.conf $(HOME)/.i3status.conf
	ln -fs `pwd`/i3/lock.sh $(XDG_CONFIG_HOME)/i3/lock.sh
	ln -fs `pwd`/i3/lock.png $(XDG_CONFIG_HOME)/i3/lock.png
	ln -fs `pwd`/i3/xrandr.sh $(XDG_CONFIG_HOME)/i3/xrandr.sh
	ln -fs `pwd`/i3/backlight.sh $(XDG_CONFIG_HOME)/i3/backlight.sh
	ln -fs `pwd`/i3/volume.sh $(XDG_CONFIG_HOME)/i3/volume.sh

bash:
	touch $(HOME)/.bashrc && echo "source ~/.bash_profile" >> $(HOME)/.bashrc
	ln -fs `pwd`/bash/bash_aliases $(HOME)/.bash_aliases
	ln -fs `pwd`/bash/bash_profile $(HOME)/.bash_profile
	ln -fs `pwd`/bash/colors $(HOME)/.colors

git:
	ln -fs `pwd`/git/gitignore $(HOME)/.gitignore
	ln -fs `pwd`/git/gitconfig $(HOME)/.gitconfig
	ln -fs `pwd`/git/git-prompt.sh $(HOME)/.git-prompt.sh
	ln -fs `pwd`/git/git-completion.sh $(HOME)/.git-completion.sh
	ln -fs `pwd`/git/diff-highlight $(HOME)/.diff-highlight

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

misc:
	ln -fs `pwd`/tigrc $(HOME)/.tigrc
	mkdir -p $(HOME)/.ssh/tmp
