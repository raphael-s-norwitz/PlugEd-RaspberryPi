#!/bin/sh

# this script automates the setup process for hostapd on a raspberry pi 3

# @author Raphael Norwitz 
#  email: raphael.s.norwitz@gmail.com
#  github:raphael-s-norwitz

instructions="https://cdn-learn.adafruit.com/downloads/pdf/setting-up-a-raspberry-pi-as-a-wifi-access-point.pdf"
# modified files
dhcpconf="/etc/dhcp/dhcpd.conf"
dhcpconfbak="$dhcpconf.bak"
dhcpconftmp="$dhcpconf.tmp"

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
# CHECK THIS (may not work out the box)
apt-get install -yes -force-yes iptables-persistent

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
numdhcprone=$(grep -n "$dhcprepone" $dhcpconf | awk -F: 'NR==1{print $1}')
numdhcprtwo=$(grep -n "$dhcpreptwo" $dhcpconf | awk -F: 'NR==1{print $1}')
numdhcprthree=$(grep -n "$dhcprepthree" $dhcpconf | awk -F: 'NR==1{print $1}') 

echo "$numdhcprone"
echo "$numdhcprtwo"
echo "$numdhcprthree"

# replace lines
awk -v num="$numdhcprone" -v to="$dhcpreponeto" 'NR==num {$0=to} 1' $dhcpconfbak > $dhcpconf
cat $dhcpconf > $dhcpconftmp
awk -v num="$numdhcprtwo" -v to="$dhcpreptwoto" 'NR==num {$0=to} 1' $dhcpconftmp > $dhcpconf
cat $dhcpconf > $dhcpconftmp
awk -v num="$numdhcprthree" -v to="$dhcprepthreeto" 'NR==num {$0=to} 1' $dhcpconftmp > $dhcpconf
rm $dhcpconftmp


# append subnet to dhcpd.conf
cat dhcp_subnet.txt >> $dhcpconf

# First run checks


