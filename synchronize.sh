OUTPUT="$HOME/.backup/config/`date +%Y-%m-%d-%I:%M:%S`.config"
echo "Overwriting $HOME/.vimrc with .vimrc" >> $OUTPUT
diff .vimrc $HOME/.vimrc >> $OUTPUT
cp .vimrc $HOME/.vimrc
echo "Overwriting $HOME/.vim with folder .vim" >> $OUTPUT
cp -rf .vim $HOME/.vim
echo "Overwriting $HOME/.profile with .profile" >> $OUTPUT
diff .profile $HOME/.profile >> $OUTPUT
cp .profile $HOME/.profile
