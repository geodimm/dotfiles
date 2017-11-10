ALL   := tmux bash vim git misc i3

install: $(ALL:%=install-%)

install-tmux:
	ln -fs `pwd`/tmux/tmux.conf ~/.tmux.conf
	ln -fs `pwd`/tmux/tnew.sh ~/tnew.sh

install-i3:
	ln -fs `pwd`/i3/config ~/.config/i3/config
	ln -fs `pwd`/i3/status ~/.i3status.conf

install-bash:
	touch ~/.bashrc && echo "source ~/.bash_profile" >> ~/.bashrc
	ln -fs `pwd`/bash/bash_aliases ~/.bash_aliases
	ln -fs `pwd`/bash/bash_profile ~/.bash_profile
	ln -fs `pwd`/bash/colors ~/.colors

install-git:
	ln -fs `pwd`/git/gitignore ~/.gitignore
	ln -fs `pwd`/git/gitconfig ~/.gitconfig
	ln -fs `pwd`/git/git-prompt.sh ~/.git-prompt.sh
	ln -fs `pwd`/git/git-completion.sh ~/.git-completion.sh
	ln -fs `pwd`/git/diff-highlight ~/.diff-highlight

install-vim:
	rm -f ~/.vim
	ln -fs `pwd`/vim ~/.vim
	ln -fs `pwd`/vim/vimrc ~/.vimrc
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim +PlugInstall +qall

install-misc:
	ln -fs `pwd`/tigrc ~/.tigrc
	mkdir -p ~/.ssh/tmp
