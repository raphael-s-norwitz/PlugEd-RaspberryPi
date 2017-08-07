#!/bin/sh

# import functions
. ../functions/functions.sh

# import key variables
. ../var/variables.sh

# this script automates the setup process for hostapd on a raspberry pi 3

# @author Raphael Norwitz 
#  email: raphael.s.norwitz@gmail.com
#  github:raphael-s-norwitz

echo "This script sets up hostapd on a Raspberry pi 3. May work on other platforms too but no promises"
echo "For more detailed instructions see: $instructions"
sleep 1
echo "NOTE: after installing dependencies, you will see a popup asking about ipv4 tables and ipv6 iptables. Just hit 'enter' twice :)"
sleep 3

# create backups
dhcpconfbak="$dhcpconf.bak"
iscdhcpconfbak="$iscdhcpconf.bak"
netconfbak="$netconf.bak"
hostapdconfbak="$hostapdconf.bak"
defaulthostapdbak="$defaulthostapd.bak"
initdconfbak="$initdconf.bak"
sysctlconfbak="$sysctlconf.bak"
hostconfsdnsbak="$hostconfsdns.bak"
dnsmasqconfbak="$dnsmasqconf.bak"

# check user privaleges
priv=$(whoami)
if [ "$priv" != "root" ]; then
	echo "This script must be run as rvoot"
	exit
fi

echo "Installing dependencies.."
# update system
apt-get update -y
# install dependencies
apt-get install -y hostapd isc-dhcp-server dnsmasq
# CHECK THIS (may not work out the box)
apt-get install -y --force-yes iptables-persistent

echo "Modifying files"
# backup dhcp configurations
cp $dhcpconf $dhcpconfbak
cp $iscdhcpconf $iscdhcpconfbak
cp $netconf $netconfbak
cp $defaulthostapd $defaulthostapdbak
cp $initdconf $initdconfbak
cp $sysctlconf $sysctlconfbak
cp $hostconfsdns $hostconfsdnsbak
cp $dnsmasqconf $dnsmasqconfbak

# swap lines for dhcp
dhcprepone="option domain-name \"example.org\";"
dhcpreponeto="#$dhcprepone"

dhcpreptwo="option domain-name-servers ns1.example.org, ns2.example.org;"
dhcpreptwoto="#$dhcpreptwo"

dhcprepthree="#authoritative"
dhcprepthreeto="authoritative;"

# swap lines for interfaces configs
iscdhcprep="INTERFACES=\"\""
iscdhcprepto="INTERFACES=\"$apinterface\""

# replace lines from dhcp conf
replace_line_string "$dhcprepone" $dhcpconf "$dhcpreponeto"
replace_line_string "$dhcpreptwo" $dhcpconf "$dhcpreptwoto"
replace_line_string "$dhcprepthree" $dhcpconf "$dhcprepthreeto"

# append subnet to dhcpd.conf
cat $dhcpconftemplate >> $dhcpconf
replace_line_string "option domain-name \"local\"" $dhcpconf " option domain-name $apphostname;"
replace_line_string "option domain-name-servers 8.8.8.8, 8.8.4.4" $dhcpconf " option domain-name-servers $apipaddr, 8.8.8.8, 8.8.4.4;"

# add configurations to isc-dhcp-server
replace_line_string $iscdhcprep $iscdhcpconf $iscdhcprepto

# take wi-fi down
sudo ifdown $apinterface

# edit network interfaces
intfacenetline=$(get_line $apinterface $netconf)
prepend_everything_after $netconf $intfacenetline \#

echo "allow-hotplug $apinterface" >> $netconf
echo "#auto $apinterface" >> $netconf
echo "iface $apinterface inet static" >> $netconf
echo " address $apipaddr" >> $netconf
echo " netmask $apnetmask" >> $netconf

# setup second interface to provide connectivity
echo "allow-hotplug $seciface" >> $netconf
echo "auto $seciface" >> $netconf 
echo "iface $seciface inet dhcp" >> $netconf
echo "	wpa-ssid \"$secssid\"" >> $netconf
echo "	wpa-psk \"$secpassword\"" >> $netconf

# set up interface
sudo ifconfig $apinterface $apipaddr

# add hostapd configuration file
cat $hostapdconftemplate > $hostapdconf

replace_line_string "interface=" $hostapdconf "interface=$apinterface"
replace_line_string "ssid=" $hostapdconf "ssid=$apssid"
replace_line_string "wpa_passphrase=" $hostapdconf "wpa_passphrase=$appass"
replace_line_string "country_code=" $hostapdconf "country_code=$apcountry"

# fix default hostapd
replace_line_string "#DAEMON_CONF=" $defaulthostapd "DAEMON_CONF=\"$hostapdconf\""

# add hostapd conf to init.d
replace_line_string "DAEMON_CONF=" $initdconf "DAEMON_CONF=$hostapdconf"

# enable forwarding
echo "net.ipv4.ip_forward=1" >> $sysctlconf

# set up forwarding immidiately
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward "

# set up iptables
sudo iptables -t nat -A POSTROUTING -o $frominterface -j MASQUERADE
sudo iptables -A FORWARD -i $frominterface -o $apinterface -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i $apinterface -o $frominterface -j ACCEPT

# display iptables (no real need to do this)
#sudo iptables -t nat -S
#sudo iptables -S

# save iptables state
sudo sh -c "iptables-save > /etc/iptables/rules.v4"

# add hostname to hosts
cat "$apipaddr	$apphostname" >> $hostconfsdns

# add to dnsmasq conf
echo "domain=$apphostname" >> $dnsmasqconf
echo "resolv-file=/etc/resolv.dnsmasq" >> $dnsmasqconf
echo "min-port=4096" >> $dnsmasqconf
echo "server=8.8.8.8" >> $dnsmasqconf
echo "sever=8.8.4.4" >> $dnsmasqconf


# remove wpa-supplicant
# sudo mv /usr/share/dbus-1/system-services/fi.epitest.hostap.WPASupplicant.service ~/
echo "Hostapd should be setup!"
echo "Now run \"sudo reboot\" to reboot the machine"
echo "After reboot, you should see the access point: $apssid"
echo "And be able to associate with it with password $appass"
