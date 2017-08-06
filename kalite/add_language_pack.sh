#!/bin/sh

if [ -z $1 || -z $2 ];
then
	echo "Run as ./add_language_pack.sh <language i.e. en, es...etc> <path to zip>"
	exit
fi

kalite manage retrievecontentpack local $1 $2
