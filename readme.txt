git clone git://github.com/KimiChen/Vim.git ~/.vim/
wget http://prdownloads.sourceforge.net/ctags/ctags-5.8.tar.gz
tar zxvf ctags-5.8.tar.gz
cd ctags-5.8
./configure
make
sudo make install
cd ..
rm -Rf ./ctags-5.8*
sudo cp /usr/local/bin/ctags /usr/bin/ctags