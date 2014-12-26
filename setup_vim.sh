#!/bin/bash
############################
# setup_vim.sh
# This scripts installs Git, Vim and Vundle
############################

########## Variables

VIM_DIR=~/.vim  # vim directory

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

git_install()
{
    hash git 2>/dev/null
    IS_GIT_INSTALLED=$?

    if [ ${IS_GIT_INSTALLED} -gt 0 ]; then
        read -r -p  "Git is not installed! Would you like to install it now? [y/n] " response
        if [[ ${response} =~ ^(yes|y|YES|Y) ]]; then
            echo "Installing Git..."
            sudo apt-get install -y git
            print_result $?
        else
            echo "Git was not installed. Aborting."
        fi
    else
        echo "Git is already installed"
    fi
}

vim_install()
{
    hash vim 2>/dev/null
    IS_VIM_INSTALLED=$?

    if [ ${IS_VIM_INSTALLED} -gt 0 ]; then
        read -r -p  "Vim is not installed! Would you like to install it now? [y/n] " response
        if [[ ${response} =~ ^(yes|y|YES|Y) ]]; then
            echo "Installing Vim..."
            sudo apt-get install -y vim
            print_result $?
        else
            echo "Vim was not installed. Aborting."
        fi
    else
        echo "Vim is already installed"
    fi
}

vundle_install()
{
    if [ ! -d ${VIM_DIR}/bundle/Vundle.vim ]; then
        read -r -p  "Vundle is not installed! Would you like to install it now? [y/n] " response
        if [[ ${response} =~ ^(yes|y|YES|Y) ]]; then
            echo -n "Installing Vundle "
            git clone https://github.com/gmarik/Vundle.vim.git ${VIM_DIR}/bundle/Vundle.vim >/dev/null 2>&1
            print_result $?
        else
            echo "Vundle was not installed. Aborting."
        fi
    else
        echo "Vundle is already installed."
    fi
}

vundle_plugins_install()
{
    hash vim 2>/dev/null
    IS_VIM_INSTALLED=$?

    if [ ${IS_VIM_INSTALLED} -eq 0 ]; then
        read -r -p  "Would you like to install Vim plugins now? [y/n] " response
        if [[ ${response} =~ ^(yes|y|YES|Y) ]]; then
            echo -n "Installing Vim plugins "
            vim +PluginClean +PluginInstall +PluginUpdate +qall
            print_result $?
        else
            echo "Plugins were not installed."
        fi
    else
        vim_install
        vundle_plugins_install
    fi
}

git_install
vim_install
vundle_install
vundle_plugins_install

