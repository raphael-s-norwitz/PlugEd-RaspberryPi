#!/bin/bash

# note bash not sh

. ../../global/var/variables.sh
. ../../global/functions/functions.sh

# assumes nginx is set up

# setup dependencies
sudo apt-get install -y python python-dev python-virtualenv pip supervisor

workdir=$(pwd)
env_name="$appname-env"

# setup virtual environment (not sure how nessesary)
mkdir $workdir/.virtualenvs && cd $workdir/.virtualenvs
virtualenv $env_name
source $workdir/.virtualenvs/pluged_dep/bin/activate

# install requirements
pip install -r ../requirements.txt


