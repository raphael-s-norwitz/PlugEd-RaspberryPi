#!/bin/sh

sudo apt-get install -y vim
cat ./config_files/.vimrc > ~/.vimrc

if [ -z $1 ];
then
	echo "rerun with arguments <First Name> <Last Name> <email>"
	exit
fi

git config --global user.name "$1 $2"
git config --global user.email "$3"

echo "Remember to enable SSH!!"
echo "run 'sudo raspi-config' then see Interfacing Options"
