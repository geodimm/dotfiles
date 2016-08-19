ALL   := tmux bash vim git 

install: $(ALL:%=install-%)

install-tmux:
	ln -fs `pwd`/tmux/tmux.conf ~/.tmux.conf

install-bash:
	touch ~/.bashrc && echo "source ~/.bash_profile" >> ~/.bashrc
	ln -fs `pwd`/bash/bash_aliases ~/.bash_aliases
	ln -fs `pwd`/bash/bash_profile ~/.bash_profile
	ln -fs `pwd`/bash/colors ~/.colors

install-git:
	ln -fs `pwd`/gitconfig ~/.gitconfig
	ln -fs `pwd`/git-prompt.sh ~/.git-prompt.sh
	ln -fs `pwd`/git-completion.sh ~/.git-completion.sh
	ln -fs `pwd`/diff-highlight ~/.diff-highlight

install-vim:
	rm -f ~/.vim
	ln -fs `pwd`/vim ~/.vim
	ln -fs `pwd`/vim/vimrc ~/.vimrc
	git submodule init
	git submodule update
	vim +PluginInstall +qall
