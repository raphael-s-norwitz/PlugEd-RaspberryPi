# PlugED's Raspberry Pi Setup

## What is this?
This repository contains code to setup a local offline network using a raspberry pi, which also doubles as Kahn Academy Lite server. Right now we plan to start using it to share educational materials in schools and elsewhere.

## What is PlugED?
TBD (Lindo and Orinea?)

## How is the code structured?
`global/` contains functions and variables which are shared among all programs we run.
`hostapd/` contains the code to setup hostapd on the device, as well as scripts to activate and deactivate the access point.
`kalite/` contains scripts to setup Kahn Academy Lite and install downloaded language packs.
`pluged_app/` contains the code for our flask application and our nginx, gunicorn, and supervisor production environment.

## Rough Setup instructions
First run `sudo raspi-config`to change password and enable ssh. Of course if you are setting up on a clean raspberry pi, you will need to first connect to the internet (which can be done via command line or by clicking the networking icon in the top right corner of the screen), and clone this repository with the command `git clone https://github.com/raphael-s-norwitz/PlugEd-RaspberryPi/`. Then check that the keyboard is working properly, and update keyboard settings accordingly. Also download the WebBrowser.apk and put it in `pluged_app/static`. Also go to the `global/` directory. It's important that you set the `secssid` and `secpassword`to the SSID and password of the Wi-Fi network you'd like the Pi to access for internet, if any.

Then download KA-lite, and set it up. There are instructions in the `kalite/` directory, but you can do it any way you want.

Next set up the PlugED flask application. Go to the `pluged_app/scripts` directory and run `sudo ./setup_nginx.sh`. When that completes, run `sudo ./setup_app`.

Finally, setup hostapd by going to the `hostapd/scripts` directory and running `sudo ./setup_hostapd.sh`.

The run `sudo reboot` and everything should work.

## Citations
### hostapd
https://cdn-learn.adafruit.com/downloads/pdf/setting-up-a-raspberry-pi-as-a-wifi-access-point.pdf

### dnsmasq
https://www.raspberrypi.org/forums/viewtopic.php?t=46154

### nginx, gunicorn, supervisor, flask
http://alexandersimoes.com/hints/2015/10/28/deploying-flask-with-nginx-gunicorn-supervisor-virtualenv-on-ubuntu.html
https://www.digitalocean.com/community/tutorials/how-to-install-and-manage-supervisor-on-ubuntu-and-debian-vps
