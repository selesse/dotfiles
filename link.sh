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
  .gitignore_global
  .my.cnf
  .ssh/config
  .tmux.conf
  .zshrc
  bin/find_parent_git
  bin/git-churn
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

# create $HOME/bin if it doesn't exist, then link all the dotfiles
mkdir -p $HOME/bin
link_files ${files[@]}

if [ ! -d "$HOME/.oh-my-zsh" ] ; then
  echo "oh-my-zsh isn't installed - not linking theme"
else
  CUSTOM_THEME_DIR=$HOME/.oh-my-zsh/custom/themes
  mkdir -p $CUSTOM_THEME_DIR
  ln -vs $GIT_DIR/aseles.zsh-theme $CUSTOM_THEME_DIR/aseles.zsh-theme
fi
