# PlugED Raspberry Pi

# What is this?

This repo presents an open-source solution which allows anyone with a Wi-Fi enabled raspberry pi to easily setup a data repository for offline storage and distribution of multimedia content. We aim to help those who want to make online educational, medical or other socially valuable resources available to their communities, but live in areas where broadband resources are expensive or inaccessable.

After the setup procedure, anyone can access the materials on the device by connecting to the WiFi Hotspot the device creates on boot up (PlUGED_AP) and searching on (plug.ed/) using a general web broswer. As is, the setup scripts automate the process of turning a raspberry pi into a Wi-Fi hotspot on boot. Then, different servers running on the pi and will be made available to connected devices via the hotspot. As an example, we have written the setup scripts for the Kahn Academy Lite application, as developed by the NGO Learning Equality. This resource includes educational videos and games taken directly from Kahn academy. 

The model of an offline platform for storing and distributing content is not new, especially to the South African context. These start-ups provide preconfigured boxes with selected educational content already loaded. Some may be more or less configurable, have xyz features...etc, but in the end there is no reason anyone should have to pay more than the baseline cost of a raspberry pi to run such a service. Further we have noticed that startups who focus on producing educational content waste time setting up their own boxes to distribute their content. We hope this helps disadvantaged people immidiately get Khan academy resources into the hands of their children without needing to pay a premium from one of these startups, and/or helps those producing educational content to seamlessly make their work available to offline communities.

We encourage NGOs, Schools, Health Centers, EdTech startups, or anyone who wants to share information offline to clone, fork and build on this solution. Contributions would be very welcome!

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

### Kahn Academy Lite
https://learningequality.org/ka-lite/
