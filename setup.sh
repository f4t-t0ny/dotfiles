#!/bin/bash
GIT_INSTALLED=$(git --version >/dev/null 2>&1 && echo true || echo false)
CURL_INSTALLED=$(curl -V >/dev/null 2>&1 && echo true || echo false)
WGET_INSTALLED=$(wget -V >/dev/null 2>&1 && echo true || echo false)

if ! $GIT_INSTALLED; then
  ERROR=$?
  echo 'git not installed, exiting...' >&2
  exit($ERROR)
fi
if ! $CURL_INSTALLED && ! $WGET_INSTALLED; then
  ERROR=$?
  echo 'Both wget and curl not installed, exiting...' >&2
  exit($ERROR)
fi

cd 
git clone https://github.com/f4t-t0ny/dotfiles .dotfiles --depth=1
cd .dotfiles
shopt -s dotglob 
mv * ..
cd
rmdir .dotfiles
if $CURL_INSTALLED; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
elif $WGET_INSTALLED; then
  mkdir -p ~/.vim/autoload >/dev/null 2>&1
  wget -q -O ~/.vim/autoload/plug.vim \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

vim +PlugInstall +qall
if [ ! -f ~/.bash_profile ]; then
  echo '. ~/.bashrc' >> ~/.bash_profile
fi
. .bash_profile
