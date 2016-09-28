#!/bin/bash

# Creates a set of symbolic links for a dotfiles repository.
#
# This script is meant to be a "quick start":
#   1. Clone your dotfiles repository
#   2. Run `link.sh`

# Assume we're running this script from the dotfiles repository root
DOTFILES_DIRECTORY=$PWD

main() {
    cd "$DOTFILES_DIRECTORY"

    # We need $HOME/bin to exist in order to create bin/* symlinks
    mkdir -p "$HOME/bin"
    shopt -s extglob
    # Glob all the dotfiles except for .git and .gitignore
    dotfiles=$(GLOBIGNORE=".git:.gitignore"; echo .??*)
    bin_files=$(find bin -type f)
    files=("${dotfiles[@]} ${bin_files[@]}")

    link_files ${files[@]}
    setup_oh_my_zsh
}

link_files() {
    cd "$HOME"

    for file in "$@" ; do
        if [[ -e $file ]] ; then
            echo Link for "$HOME/$file" already exists - not doing anything
        else
            ln -vs "$DOTFILES_DIRECTORY/$file" "$file"
        fi
    done
}

setup_oh_my_zsh() {
    install_oh_my_zsh
    setup_oh_my_zsh_theme
}

install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ] ; then
        echo "oh-my-zsh isn't installed - cloning from git"
        git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    fi
}

setup_oh_my_zsh_theme() {
    CUSTOM_THEME_DIR=$HOME/.oh-my-zsh/custom/themes

    if [ ! -L "$CUSTOM_THEME_DIR/aseles.zsh-theme" ] ; then
        mkdir -p "$CUSTOM_THEME_DIR"
        ln -vs "$DOTFILES_DIRECTORY/aseles.zsh-theme" "$CUSTOM_THEME_DIR/aseles.zsh-theme"
    fi
}

main
