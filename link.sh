#!/bin/bash

# Creates a set of symbolic links for a dotfiles repository.
#
# This script is meant to be a "quick start":
#   1. Clone your dotfiles repository
#   2. Run `link.sh`

# Assume we're running this script from the dotfiles repository root
DOTFILES_DIRECTORY=$PWD

cd $HOME
files=(
    .bashrc
    .gitconfig
    .githelpers
    .gitignore_global
    .ideavimrc
    .inputrc
    .my.cnf
    .profile
    .tmux.conf
    .vim
    .vimrc
    .zshrc
    bin/find-parent-git
    bin/get-password
    bin/git-churn
    bin/run-command-on-git-revisions
)

function main {
    # We need $HOME/bin to exist in order to create bin/* symlinks
    mkdir -p $HOME/bin
    link_files ${files[@]}

    setup_oh_my_zsh
}

function link_files() {
    for file in $@ ; do
        if [ -e $file ] ; then
            echo $HOME/$file already exists - aborting link
        else
            ln -vs $DOTFILES_DIRECTORY/$file $file
        fi
    done
}

function setup_oh_my_zsh {
    install_oh_my_zsh
    setup_oh_my_zsh_theme
}

function install_oh_my_zsh {
    if [ ! -d "$HOME/.oh-my-zsh" ] ; then
        echo "oh-my-zsh isn't installed - cloning from git"
        git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    fi
}

function setup_oh_my_zsh_theme {
    CUSTOM_THEME_DIR=$HOME/.oh-my-zsh/custom/themes

    if [ ! -L "$CUSTOM_THEME_DIR/aseles.zsh-theme" ] ; then
        mkdir -p $CUSTOM_THEME_DIR
        ln -vs $DOTFILES_DIRECTORY/aseles.zsh-theme $CUSTOM_THEME_DIR/aseles.zsh-theme
    fi
}

main
