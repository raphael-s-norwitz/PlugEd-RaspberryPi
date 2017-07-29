#!/bin/sh

# this script automates the setup process for hostapd on a raspberry pi 3

#@author Raphael Norwitz 
# email: raphael.s.norwitz@gmail.com
# github:raphael-s-norwitz

instructions="https://cdn-learn.adafruit.com/downloads/pdf/setting-up-a-raspberry-pi-as-a-wifi-access-point.pdf"
# modified files
dhcpconf="/etc/dhcp/dhcpd.conf"

# Check key info

# check user privaleges
priv=$(whoami)
#echo "$priv"
if [ "$priv" != "root" ]; then
	echo "This script must be run as root"
	exit
fi

# update system
#apt-get update -y
# install dependencies
#apt-get install -y hostapd isc-dhcp-server
# CHECK THIS (may not work out the box)
#apt-get install -yes -force-yes iptables-persistent

# fix dhcp configuration file

# first backup dhcp conf 
cp $dhcpconf $dhcpconf.bak

# these lines need to be swapped out from default configs
dhcprepone="option domain-name \"example.org\";"
dhcpreponeto="#$dhcprepone"

dhcpreptwo="option domain-name-servers ns1.example.org, ns2.example.org;"
dhcpreptwoto="#$dhcpreptwo"

dhcprepthree="#authoritative"
dhcprepthreeto="authoritative"

echo "$dhcprepone"
echo "$dhcpreponeto"
echo "$dhcpreptwo"
echo "$dhcpreptwoto"
echo "$dhcprepthree"
echo "$dhcprepthreeto"

# get lines to be swaped
numdhcprone=$(grep -n $dhcprepone $dhcpconf | awk -F: 'NR==1{print $1}')
numdhcprtwo=$(grep -n $dhcpreptwo $dhcpconf | awk -F: 'NR==1{print $1}')
numdhcprthree=$(grep -n $dhcprepthree $dhcpconf | awk -F: 'NR==1{print $1}') 

# replace lines
sed -i '/$numdhcprone/c/$dhcpreponeto' $dhcpconf
sed -i '/$numdhcprtwo/c/$dhcpreptwoto' $dhcpconf
sed -i '/$numdhcprthree/c/$dhcprepthreeto' $dhcpconf

# append subnet to dhcpd.conf
cat dhcp_subnet.txt >> $dhcpconf

# First run checks


