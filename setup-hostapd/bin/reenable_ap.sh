#!/bin/sh

# this script re-enables a disabled access point 
# the Wi-Fi network specified in seciface and secpassword in ../var/variables.sh

# include variables
. ../var/variables.sh

# replace lines in interface configs
replace_line_string "auto $apinterface" $netconf "\#auto $apinterface"
replace_line_string "iface $apinterface inet dhcp" $netconf "iface $apinterface inet static"
replace_line_string "	wpa-ssid \"$secssid\"" $netconf " address $apipaddr"
replace_line_string "	wpa-psk \"$secpassword\"" $netconf " netmask $apnetmask"

# if you were getting rid of wpa-supplicant, get rid of it again
# sudo mv /usr/share/dbus-1/system-services/fi.epitest.hostap.WPASupplicant.service ~/
