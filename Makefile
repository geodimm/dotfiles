XDG_CONFIG_HOME ?= $(HOME)/.config
ZSH_CUSTOM ?= ~/.oh-my-zsh/custom

deps:
	sudo apt install -y \
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
		jq \
		bat

.PHONY: tmux
tmux:
	mkdir -p ~/.tmux/themes
	git clone https://github.com/srcery-colors/srcery-tmux/ \
		~/.tmux/themes/srcery-tmux || true
	ln -fs `pwd`/tmux/tmux.conf $(HOME)/.tmux.conf
	ln -fs `pwd`/tmux/tnew.sh $(HOME)/tnew.sh

.PHONY: i3
i3:
	mkdir -p $(XDG_CONFIG_HOME)/i3
	ln -fs `pwd`/i3/config $(XDG_CONFIG_HOME)/i3/config
	ln -fs `pwd`/i3/status.conf $(HOME)/.i3status.conf
	mkdir -p $(XDG_CONFIG_HOME)/dunst
	ln -fs `pwd`/i3/dunstrc $(XDG_CONFIG_HOME)/dunst/dunstrc

.PHONY: zsh
zsh:
	ln -fs `pwd`/zsh/zshrc ~/.zshrc
	ln -fs `pwd`/zsh/custom/themes/oxide.zsh-theme $(ZSH_CUSTOM)/themes/oxide.zsh-theme
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
		$(ZSH_CUSTOM)/plugins/zsh-syntax-highlighting || true
	git clone https://github.com/zsh-users/zsh-autosuggestions \
		$(ZSH_CUSTOM)/plugins/zsh-autosuggestions || true
	git clone https://github.com/romkatv/powerlevel10k.git \
		$(ZSH_CUSTOM)/themes/powerlevel10k || true

.PHONY: git
git:
	ln -fs `pwd`/git/gitconfig $(HOME)/.gitconfig

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
	ln -fs `pwd`/tig/tigrc $(HOME)/.tigrc
	mkdir -p $(HOME)/.ssh/tmp
