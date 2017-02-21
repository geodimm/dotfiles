ALL   := tmux bash vim git 

install: $(ALL:%=install-%)

install-tmux:
	ln -fs `pwd`/tmux/tmux.conf ~/.tmux.conf
	ln -fs `pwd`/tmux/tnew.sh ~/tnew.sh

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
	git submodule init
	git submodule update
	vim +PluginInstall +qall
