#!/bin/sh

# this script disables the access point and enables 
# the Wi-Fi network specified in seciface and secpassword in ../var/variables.sh

# include variables
. ../var/variables.sh

# replace lines in interface configs
replace_line_string "\#auto $apinterface" $netconf "auto $apinterface"
replace_line_string "iface $apinterface inet static" $netconf "iface $apinterface inet dhcp"
replace_line_string " address $apipaddr" $netconf "	wpa-ssid \"$secssid\""
replace_line_string " netmask $apnetmask" $netconf "	wpa-psk \"$secpassword\""
