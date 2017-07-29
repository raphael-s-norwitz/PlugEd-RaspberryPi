#!/bin/sh

# this script automates the setup process for hostapd on a raspberry pi 3

#@author Raphael Norwitz 
# email: raphael.s.norwitz@gmail.com
# github:raphael-s-norwitz

# Check key info

# check user privaleges
priv=$(whoami)
#echo "$priv"

if [ "$priv" != "root" ]; then
	echo "This script must be run as root"
	exit
fi

# update system
apt-get update -y
# install dependencies
apt-get install -y hostapd isc-dhcp-server
apt-get install -y iptables-persistent



# First run checks


