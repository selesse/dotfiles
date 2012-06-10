echo "Overwriting $HOME/.vimrc with .vimrc"
diff .vimrc $HOME/.vimrc
cp .vimrc $HOME/.vimrc
echo "Overwriting $HOME/.vim with folder .vim"
cp -rf .vim $HOME/.vim
echo "Overwriting $HOME/.profile with .profile"
diff .profile $HOME/.profile
cp .profile $HOME/.profile
