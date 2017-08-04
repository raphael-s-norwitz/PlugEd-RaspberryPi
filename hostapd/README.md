# Hostapd setup

This directory contains scripts which automate the setup of the Access Point on a Raspberry Pi 3

## Instructions
Before you do anything, enable SSH.

Do this by running 
```sudo raspi-config```
and selecting SSH from interfacing options

Then open
```var/variables.sh```
and change the variables. The important ones are 'apssid' and 'appass' which will be the ssid of the network hostapd creates and the password to associate with the access point.

There is also secssid and secpassword, which are the identifiers of a real Wi-Fi network you may wish to connect to with the pi.

## Setup

Once you've set the variables, run ```sudo ./scripts/setup-hostapd.sh```. Then reboot the system.
When it comes back on you should see the network up and running.

If you want to connect back to a network, run ```sudo ./scripts/disable_ap.sh``` and then reboot the device.

If you then want to turn the access point back on run ```sudo ./scripts/reenable_ap.sh```


That's basically it
