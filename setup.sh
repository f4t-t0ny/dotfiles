#!/bin/sh

cd 
git clone https://github.com/f4t-t0ny/dotfiles .dotfiles --depth=1
cd .dotfiles
shopt -s dotglob 
mv * ..
cd
rmdir .dotfiles
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
. .bashrc
