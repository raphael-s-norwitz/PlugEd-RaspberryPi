#!/bin/sh

# this script disables the access point and enables 
# the Wi-Fi network specified in seciface and secpassword in ../var/variables.sh

# include functions
. ../functions/functions.sh

# include variables
. ../var/variables.sh

# check user privaleges
root_check
root_val=$?

if [ $root_val -eq 1 ];
then
	echo "This script must run as root"
	echo "rerun as: sudo disable_ap.sh"
	exit
fi

# replace lines in interface configs
replace_line_string "#auto $apinterface" $netconf "auto $apinterface"
replace_line_string "iface $apinterface inet static" $netconf "iface $apinterface inet dhcp"
replace_line_string " address $apipaddr" $netconf "	wpa-ssid \"$secssid\""
replace_line_string " netmask $apnetmask" $netconf "	wpa-psk \"$secpassword\""

# put wpa supplicant back if you got rid of it
# sudo mv ~/fi.epitest.hostap.WPASupplicant.service /usr/share/dbus-1/system-services/fi.epitest.hostap.WPASupplicant.service
echo "Done!"
echo "reboot with \"sudo reboot\" to connect to Wi-Fi"
