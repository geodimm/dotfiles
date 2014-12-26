ALL   := bash vim

update:
	git pull
	git submodule sync
	git submodule foreach "git checkout master; git pull origin master; echo"
	$(MAKE) install

install: $(ALL:%=install-%)

install-bash:
	echo "source ~/.bash_profile" >> ~/.bashrc
	ln -fs `pwd`/bash/bash_profile ~/.bash_profile

install-vim:
	[[ -d ~/.vim ]] || ( git clone git@github.com:georgijd/vimfiles.git ~/.vim && cd ~/.vim && make install )
