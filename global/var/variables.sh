#!/bin/sh

# args
apinterface="wlan0"
seciface="wlan1"
frominterface="eth0"
apipaddr="192.168.42.1"
apnetmask="255.255.255.0"
apssid="Pluged_AP"
appass="Plugedza"
apcountry="US"

secssid="name_of_access_point"
secpassword="passwordforssid"

appname="pluged_app"

# links
hostapd_instructions="https://cdn-learn.adafruit.com/downloads/pdf/setting-up-a-raspberry-pi-as-a-wifi-access-point.pdf"
browser_apk_link="http://www.appsapk.com/downloading/latest/Web%20Browser%20&%20Explorer.apk"

# modified files
dhcpconf="/etc/dhcp/dhcpd.conf"
iscdhcpconf="/etc/default/isc-dhcp-server"
netconf="/etc/network/interfaces"
hostapdconf="/etc/hostapd/hostapd.conf"
defaulthostapd="/etc/default/hostapd"
initdconf="/etc/init.d/hostapd"
sysctlconf="/etc/sysctl.conf"

nginxconfavail="/etc/nginx/sites-available"
nginxconfen="/etc/nginx/sites-enabled"


# templates
dhcpconftemplate="../templates/dhcp_subnet.txt"
hostapdconftemplate="../templates/hostapdconf.txt"


