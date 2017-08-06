#!/bin/bash

# note bash not sh

. ../../global/var/variables.sh
. ../../global/functions/functions.sh

# must run as root
root_check
root_val=$?

if [ $root_val -eq 1 ]; 
then
	echo "This script must be run as root"
	echo "rerun: sudo setup_app.sh"
	exit
fi


# setup dependencies
sudo apt-get install -y python python-dev python-virtualenv python-pip supervisor

cd ..
workdir=$(pwd)

pip install virtualenv

env_name="$appname-env"

# setup virtual environment (not sure how nessesary)
mkdir $workdir/.virtualenvs && cd $workdir/.virtualenvs
virtualenv $env_name
source $workdir/.virtualenvs/$env_name/bin/activate

cd ..

# install requirements
pip install -r ./requirements.txt

pgsupviconf="$supvisconf/pluged_app.conf"

# setup supervisor
cat ../global/static_configs/supervisor_config.conf > $pgsupviconf
replace_line_string "[program: ]" $pgsupviconf "[program:pluged_app]"
replace_line_string "command = /bin/gunicorn" $pgsupviconf "command = $workdir/.virtualenvs/$env_name/bin/gunicorn pluged_app:app"
replace_line_string "directory =" $pgsupviconf "directory = $workdir"
replace_line_string "stdout_logfile = /logs/gunicorn/gunicorn_stdout.log" $pgsupviconf "stdout_logfile = $workdir/logs/gunicorn/gunicorn_stdout.log"
replace_line_string "stderr_logfile = /logs/gunicorn/gunicorn_stderr.log" $pgsupviconf "stderr_logfile = $workdir/logs/gunicorn/gunicorn_stderr.log"

mkdir -p $workdir/logs/gunicorn

sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start pluged_app
