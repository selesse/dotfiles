#!/bin/bash
cd $HOME
ln -s ~/git/config/.profile .profile
ln -s ~/git/config/.vim .vim
ln -s ~/git/config/.vimrc .vimrc
ln -s ~/git/config/.gitconfig .gitconfig
ln -s ~/git/config/.my.cnf .my.cnf
mkdir .ssh
ln -s ~/git/config/.ssh/config .ssh/config
