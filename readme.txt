based on http://amix.dk/vim/vimrc.txt

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

sh ~/.vim/install.sh mac


git clone git@github.com:KimiChen/Vim.git .vim/
git config --global user.name "KimiChen"
git config --global user.email "jianxieshui|*|gmail.com"
git remote add origin git@github.com:KimiChen/Vim.git
git pull git@github.com:KimiChen/Vim.git
git push origin master



git config user.name "KimiChen"
git config user.email "jianxieshui@gmail.com"
