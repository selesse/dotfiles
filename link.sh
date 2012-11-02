#!/bin/bash
GIT_DIR=$PWD

cd $HOME
files=(
  .profile
  .bashrc
  .vim
  .vimrc
  .gitconfig
  .my.cnf
  .ssh/config
  .tmux.conf
)

function link_files() {
  for file in $@ ; do
    if [ -e $file ] ; then
      echo $HOME/$file already exists - aborting link
    else
      echo ln -s $GIT_DIR/$file $file
    fi
  done
}

link_files ${files[@]}
