#!/bin/sh

# import functions
. ./functions/functions.sh

# this script automates the setup process for hostapd on a raspberry pi 3

# @author Raphael Norwitz 
#  email: raphael.s.norwitz@gmail.com
#  github:raphael-s-norwitz

# args
apinterface="wlan0"
frominterface="eth0"
apipaddr="192.168.42.1"
apnetmask="255.255.255.0"
apssid="Pluged_AP"
appass="Plugedza"
apcountry="US"


# manual instructions
instructions="https://cdn-learn.adafruit.com/downloads/pdf/setting-up-a-raspberry-pi-as-a-wifi-access-point.pdf"

# modified files
dhcpconf="/etc/dhcp/dhcpd.conf"
iscdhcpconf="/etc/default/isc-dhcp-server"
netconf="/etc/network/interfaces"
hostapdconf="/etc/hostapd/hostapd.conf"
defaulthostapd="/etc/default/hostapd.conf"
initdconf="/etc/init.d/hostapd"
sysctlconf="/etc/sysctl.conf"

# create backups
dhcpconfbak="$dhcpconf.bak"
iscdhcpconfbak="$iscdhcpconf.bak"
netconfbak="$netconf.bak"
hostapdconfbak="$hostapdconf.bak"
defaulthostapdbak="$defaulthostapdbak"
initdconfbak="$initdconf.bak"
sysctlconfbak="$sysctlconf.bak"

# templates
dhcpconftemplate="./templates/dhcp_subnet.txt"
hostapdconftemplate="./templates/hostapdconf.txt"

# backup dhcp configurations
cp $dhcpconf $dhcpconf.bak
cp $iscdhcpconf $iscdhcpconfbak
cp $netconf $netconfbak
cp $defaulthostapd $defaulthostapdbak
cp $initdconf $initdconfbak
cp $sysctlconf $sysctlconfbak

# Check key info

# check user privaleges
priv=$(whoami)
#echo "$priv"
if [ "$priv" != "root" ]; then
	echo "This script must be run as rvoot"
	exit
fi

# update system
apt-get update -y
# install dependencies
apt-get install -y hostapd isc-dhcp-server
# CHECK THIS (may not work out the box)
apt-get install -yes -force-yes iptables-persistent


# these lines need to be swapped out from default configs
dhcprepone="option domain-name \"example.org\";"
dhcpreponeto="#$dhcprepone"

dhcpreptwo="option domain-name-servers ns1.example.org, ns2.example.org;"
dhcpreptwoto="#$dhcpreptwo"

dhcprepthree="#authoritative"
dhcprepthreeto="authoritative"


iscdhcprep="INTERFACES=\"\""
iscdhcprepto="INTERFACES=\"$apinterface\""

# replace lines from dhcp conf
replace_line_string $dhcprepone $dhcpconf $dhcprepone
replace_line_string $dhcpreptwo $dhcpconf $dhcpreptwo
replace_line_string $dhcprepthree $dhcpconf $dhcprepthree

# append subnet to dhcpd.conf
cat $dhcpconftemplate >> $dhcpconf

# add configurations to isc-dhcp-server
replace_line_string $iscdhcprep $iscdhcpconf $iscdhcprepto

# take wi-fi down
sudo ifdown $apinterface


# edit network interfaces
intfacenetline=$(get_line $apinterface $netconf)
prepend_everything_after $netconf $intfacenetline \#

echo "allow-hotplug $apinterface" >> $netconf
echo "iface $apinterface inet static" >> $netconf
echo " address $apipaddr" >> $netconf
echo " netmast $apnetmast" >> $netconf

# set up interface
sudo ifconfig $apinterface $apipaddr

# add hostapd configuration file
cat $hostapdconftemplate > $hostapdconf

replace_line_string interface= $hostapdconf interface=$apinterface
replace_line_string ssid= $hostapdconf ssid=$apssid
replace_line_string wpa-passphrase= $hostapdconf wpa-passphrase=$appass
replace_line_string country= $hostapdconf country=$apcountry

# fix default hostapd
replace_line_string \#DAEMON_CONF= $defaulthostapd DAEMON_CONF="$hostapdconf"

# add hostapd conf to init.d
replace_line_String DAEMON_CONF= $initdconf DAEMON_CONF=$hostapdconf

# enable forwarding
echo "net.ipv4.ip_forward=1" >> $sysctlconf

# set up forwarding immidiately
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward "

# set up iptables
sudo iptables -t nat -A POSTROUTING -o $frominterface -j MASQUERADE
sudo iptables -A FORWARD -i $frominterface -o $apinterface -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i $apinterface -o $frominterface -j ACCEPT

# display iptables (no real need to do this)
# sudo iptables -t nat -S
# sudo iptables -S

# save iptables state
sudo sh -c "iptables-save > /etc/iptables/rules.v4"

# remove wpa-supplicant
# sudo mv /usr/share/dbus-1/system-services/fi.epitest.hostap.WPASupplicant.service ~/
