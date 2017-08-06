#!/bin/sh

. ../../global/var/variables.sh
. ../../global/functions/functions.sh

pgnginxconf="$nginxconfavail/$appname"

# make sure script is run as root
root_check
root_val=$?

if [ $root_val -eq 1 ]; 
then
	echo "This script must be run as root"
	echo "Rerun as: sudo setup_nginx.sh"
	exit
fi

# install packages
sudo apt-get install -y nginx

# get browser (probably move elsewhere)
wget -O ../static/WebBrowser.apk $browser_apk_link 

# get working directroy
cd ..
workdir=$(pwd)

# remove nginx default sites-enabled
rm /etc/nginx/sites-enabled/default

# setup nginx config
cat ../global/static_configs/nginx_pluged_config > $pgnginxconf
replace_line_string "server_name ;" $pgnginxconf "    server_name $apipaddr;"
replace_line_string "root name;" $pgnginxconf "    root $workdir;"
replace_line_string "access_log /logs/nginx/access.log;" $pgnginxconf "    access_log $workdir/logs/nginx/access.log;"
replace_line_string "error_log /logs/nginx/error.log;" $pgnginxconf "    access_log $workdir/logs/nginx/error.log;"
replace_line_string "alias /static/;" $pgnginxconf "	alias $workdir/static/;"

mkdir -p $workdir/logs/nginx

# link to enabled sites and run
ln -s $pgnginxconf $nginxconfen
nginx -t
sudo service nginx restart

