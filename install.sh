if [ "$1" == "" ]; then
  echo ""
  echo "Usage to install :"
  echo "   sh .vim/install.sh <system>"
  echo "      - where <system> can be 'mac', 'linux' or 'windows'"
  exit 1
fi
echo '
fun! MySys()
   return "$1"
endfun
set runtimepath=~/.vim,~/.vim/after,\$VIMRUNTIME
source ~/.vim/vimrc
helptags ~/.vim/doc' > ~/.vimrc
echo "Installed successfully! Enjoy :)"
