#!/bin/sh

# this script automates the setup process for hostapd on a raspberry pi 3

# @author Raphael Norwitz 
#  email: raphael.s.norwitz@gmail.com
#  github:raphael-s-norwitz

# args
apinterface="wlan0"
frominterface="eth0"
apipaddr="192.168.42.1"
apnetmask="255.255.255.0"


# manual instructions
instructions="https://cdn-learn.adafruit.com/downloads/pdf/setting-up-a-raspberry-pi-as-a-wifi-access-point.pdf"

# modified files
dhcpconf="/etc/dhcp/dhcpd.conf"
iscdhcpconf="/etc/default/isc-dhcp-server"
netconf="/etc/network/interfaces"

# create backups
dhcpconfbak="$dhcpconf.bak"
iscdhcpconfbak="$iscdhcpconf.bak"
netconfbak="$netconf.bak"

# backup dhcp configurations
# cp $dhcpconf $dhcpconf.bak
# cp $iscdhcpconf $iscdhcpconfbak
# cp $netconf $netconfbak


# Check key info

# check user privaleges
priv=$(whoami)
#echo "$priv"
if [ "$priv" != "root" ]; then
	echo "This script must be run as root"
	exit
fi

# update system
# apt-get update -y
# install dependencies
# apt-get install -y hostapd isc-dhcp-server
# CHECK THIS (may not work out the box)
# apt-get install -yes -force-yes iptables-persistent

# fix dhcp configuration file

# first backup dhcp conf 

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


iscdhcprep="INTERFACES=\"\""
iscdhcprepto="INTERFACES=\"$apinterface\""

# first param: line to replace
# second param: file to replace it in
# should be ONLY 1 occurance in file
replace_line_string () {
	if [ -z "$1" ];
	then
		echo "missing args"
		return 1
	elif [ -z "$2" ];
	then
		echo "missing second arg"
		return 1
	fi

	# args
	toreplace="$1"
	file="$2"
	newline="$3"
	filetmp="$2.shcp.tmp"

	# get line number
	linenum=$(grep -n "$1" $2 | awk -F: 'NR==1{print $1}')

	# copy file
	cp $file $filetmp
	
	# replace line and go to original file
	awk -v num="$linenum" -v to="$newline" 'NR==num {$0=to} 1' $filetmp > $file

	# remove intermediate file
	rm $filetmp

	return 0
}

# first is the string to find
# sencond if the file
get_line () {
	if [ -z "$1" ];
	then
		echo "missing args"
		return 1
	elif [ -z "$2" ];
	then
		echo "missing second arg"
		return 1
	fi
	
	tofind="$1"
	file="$2"

	# find line number
	grep -n "$tofind" $file | awk -F: 'NR==1{print $1}'
	
	return 0
}

# put value in front
prepend_line () {
	repstr="#"

	if [ -z "$1" ];
	then
		echo "missing line number"
		return 1
	elif [ -z "$2" ];
	then
		echo "missing file"
		return 1
	elif [ -z "$3" ];
	then
		repstr="$3"
	fi

	line="$2"
	file="$1"
	filetmp="$1.tmp"

	# get tmp
	cp $file $filetmp

	awk -v linenum="$line" -v rstr="$repstr" 'NR==linenum {$0=rstr$0} 1' $filetmp > $file
	
	rm $filetmp

	return 0
}

prepend_everything_after () {
	repstr="#"

	if [ -z "$1" ];
	then
		echo "missing line number"
		return 1
	elif [ -z "$2" ];
	then
		echo "missing file"
		return 1
	elif [ -z "$3" ];
	then
		repstr="$3"
	fi

	line="$2"
	file="$1"
	filetmp="$1.tmp"

	# get tmp
	cp $file $filetmp

	awk -v linenum="$line" -v rstr="$repstr" 'NR >= linenum {$0=rstr$0} 1' $filetmp > $file
	
	rm $filetmp

	return 0
}






# replace lines from dhcp conf
# replace_line_string $dhcprepone $dhcpconf $dhcprepone
# replace_line_string $dhcpreptwo $dhcpconf $dhcpreptwo
# replace_line_string $dhcprepthree $dhcpconf $dhcprepthree

# append subnet to dhcpd.conf
# cat dhcp_subnet.txt >> $dhcpconf

# test replace line function
# replace_line_string newline ./test.txt works
# replace_line_string works ./test.txt newline

# add configurations to isc-dhcp-server
# replace_line_string $iscdhcprep $iscdhcpconf $iscdhcprepto

# take wi-fi down
# sudo ifdown $apinterface


# test get line and prepend functions
#linez=$(get_line second ./test.txt)
#echo $linez
# echo "---"
#cat ./test.txt
#echo "---"
#prepend_line ./test.txt $linez \#
#cat ./test.txt
#echo "---"
#prepend_everything_after ./test.txt $linez \#
#cat ./test.txt


# edit network interfaces
intfacenetline=$(get_line $apinterface $netconf)
prepend_everything_after $netconf $intfacenetline \#

echo "allow-hotplug $apinterface" >> $netconf
echo "iface $apinterface inet static" >> $netconf
echo " address $apipaddr" >> $netconf
echo " netmast $apnetmast" >> $netconf
echo ---

