#!/bin/sh

cd 
git clone https://github.com/f4t-t0ny/dotfiles .dotfiles
cd .dotfiles
shopt -s dotglob 
mv * ..
cd
rmdir .dotfiles
git submodule update --init .
vim +PluginInstall +qall
