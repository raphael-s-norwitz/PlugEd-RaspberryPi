#!/bin/sh

# ASSUMES you've already set up KA Lite

# install packages
sudo apt-get install -y nginx gunicorn python-dev python-virtualenv python pip nginx supervisor

# get browser
wget -O ../File_Download/WebBrowser.apk "http://www.appsapk.com/downloading/latest/Web%20Browser%20&%20Explorer.apk" 

