#!/bin/sh

sudo apt-get install -y vim
cat ./config_files/.vimrc > ~/.vimrc

git config --global user.name "$1 $2"
git config --global user.email "$3"
