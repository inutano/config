# copy dotfiles in $HOME
BASEDIR=$(dirname "$0")

echo "Copying dotfiles.."

cp $BASEDIR/.gitconfig $HOME
cp $BASEDIR/.screenrc $HOME
cp $BASEDIR/.tmux.conf $HOME

echo "Done."
