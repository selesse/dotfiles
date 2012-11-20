#!/bin/bash
GIT_DIR=$PWD

cd $HOME
files=(
  .profile
  .bashrc
  .vim
  .vimrc
  .gitconfig
  .githelpers
  .my.cnf
  .ssh/config
  .tmux.conf
  .zshrc
  bin/find_parent_git
)

function link_files() {
  for file in $@ ; do
    if [ -e $file ] ; then
      echo $HOME/$file already exists - aborting link
    else
      ln -vs $GIT_DIR/$file $file
    fi
  done
}

link_files ${files[@]}
