OUTPUT="$HOME/.backup/config/`date +%Y-%m-%d-%I:%M:%S`.config"
echo "Overwriting .vimrc with $HOME/.vimrc" >> $OUTPUT
diff $HOME/.vimrc .vimrc >> $OUTPUT
cp $HOME/.vimrc .vimrc 
echo "Overwriting .vim with folder $HOME/.vim" >> $OUTPUT
cp -rf $HOME/.vim .
echo "Overwriting .profile with $HOME/.profile" >> $OUTPUT
diff $HOME/.profile .profile >> $OUTPUT
cp $HOME/.profile .profile
echo "Overwriting .gitconfig with $HOME/.gitconfig" >> $OUTPUT
diff $HOME/.gitconfig .gitconfig >> $OUTPUT
cp $HOME/.gitconfig .gitconfig

# macs have a different version of cut
if [ `uname -s` == "Darwin" ] ; then
  LINES=`wc -l $OUTPUT | cut -d " " -f 8`
else
  LINES=`wc -l $OUTPUT | cut -f1 -d' '`
fi

if [ "$LINES" = "4" ] ;
  then
    echo "No changes made.";
    rm $OUTPUT
  else
    echo "$LINES is not 4";
    echo "Work complete.";
fi
