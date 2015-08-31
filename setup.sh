#!/bin/sh

cd 
git clone https://github.com/dotfiles .dotfiles
cd .dotfiles
shopt -s dotglob 
mv * ..
cd
rmdir dotfiles
git submodule update --init .
vim +PluginInstall +qall
