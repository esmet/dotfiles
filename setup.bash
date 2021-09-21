files=".vimrc .bashrc .tmux.conf"
for f in $files ; do
    fullpath="$HOME/$f"
    rm -f $fullpath
    nodot=$(echo $f | sed 's/^\.//')
    ln -s "$PWD/$nodot" $fullpath
done

mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/autoload

# Install vundle. Later, run :PluginInstall
if [ ! -d ~/.vim/bundle/Vundle.vim ] ; then
    echo 'Installing vundle ...'
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    echo ''
fi
