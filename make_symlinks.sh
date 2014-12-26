#!/bin/bash
############################
# make_symlinks.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

DIR=~/dotfiles  # dotfiles directory
OLDDIR=~/backup_dotfiles  # old dotfiles backup directory
FILES="bash_profile vimrc git-prompt.sh xaxa baba"  # list of files/folders to symlink in homedir

COL_GREEN="\x1b[32;01m"  # green colour for OK messages
COL_RED="\x1b[31;01m"  # red colour for ERROR messages
COL_RESET="\x1b[39;49;00m"  # reset to default colour (white)
##########

print_result()
{
    if [ $1 -eq 0 ]; then
        echo -e ${COL_GREEN}"[OK]"${COL_RESET}
    else
        echo -e ${COL_RED}"[ERROR]"${COL_RESET}
    fi
    return $1
}

create_backup_dir()
{
    echo -n "Creating $OLDDIR for backup of any existing dotfiles in $HOME "
    mkdir -p $OLDDIR
    print_result $?
}

backup_dotfiles()
{
    echo -n "Moving any existing dotfiles in $HOME to $OLDDIR "
    flag=1
    for file in $FILES; do
        if [ -f $HOME/.$file -a ! -L $HOME/.$file ]; then
            if [ $flag -eq 1 ]; then echo; flag=0; fi
            echo -n "    Moving $HOME/.$file to $OLDDIR/$file "
            mv $HOME/.$file $OLDDIR/
            print_result $?
        fi
    done
    if [ $flag -eq 1 ]; then print_result $?; fi
}

create_symlinks()
{
    echo -n "Creating symlinks to files in $DIR "
    flag=1
    for file in $FILES; do
        if [ ! -L $HOME/.$file ]; then
            if [ $flag -eq 1 ]; then echo; flag=0; fi
            echo -n "    Creating symlink $HOME/.$file -> $DIR/$file "
            ln -s $DIR/$file $HOME/.$file
            print_result $?
        fi
    done
    if [ $flag -eq 1 ]; then print_result $?; fi
}

create_backup_dir
backup_dotfiles
create_symlinks
