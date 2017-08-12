#!/bin/sh

# move to base directory
cd ..

# ADD CODE HERE TO CONFIGURE VAR

# run setup kalite
cd kalite/
sudo ./setup_kalite.sh
cd ..

# run app setup
cd pluged_app/scripts
sudo ./setup_nginx.sh
sudo ./setup_app.sh
cd ../../

# run hostapd setup
cd hostapd/scripts
sudo ./setup_hostapd.sh

sudo reboot
