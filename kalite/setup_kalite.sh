#!/bin/sh

# update system
sudo apt-get update

# install dependencies
sudo apt-get install -y python-m2crypto python-pkg-resources nginx python-psutil

# Fetch the latest .deb
sudo wget https://learningequality.org/r/deb-pi-installer-0-17 --no-check-certificate --content-disposition

# Install the .deb
sudo dpkg -i ka-lite-raspberry-pi*.deb
