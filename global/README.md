# Global Variables for PlugED
The files in this folder have variables and values shared between all the programs we are running on the RPi.

For now `var/variables.sh` is the most important for most usecases. There are a number of fields which one might wish to change, including:
- The name of the access point
- The hostname of the PlugED application
- The Wi-Fi interface on which the access point runs
- A second Wi-Fi interface to run on, if it exists

And most importantly:
- an SSID for a second network to connect to if another interface is available, or if the access point is deactivated by `deactivate_ap.sh`
- a password for that SSID

This should be set first thing before using any of the code on this repo

The `functions/`contains everything pertaining to shell functions. `functions/functions.sh`contains all the shell functions the various scripts in the repo use. 
There's also a (short) set of unit tests for these functions in the 'unit_tests/` directory.

The `static_configs/`directory contains files with configurations which are moved and appended to various system configuration files. This shouldn't need to be touched.
