#!/bin/bash
#
# preinstall.sh
#
# This script is used to install Useful tools and create default install directory 
#
#
# Authors:
#  Silas VIGAN <sisedaro05k@yahoo.fr>
#
# 
SOCENGINE_HOME=/opt/socengine
SOCENGINE_LOG=/opt/socengine/logs
sourcelist=./sources.list
if !(test -d $SOCENGINE_HOME);
then 
	sudo mkdir $SOCENGINE_HOME
	sudo mkdir $SOCENGINE_LOG
fi

####################################################
#              Checking the source list            #
####################################################
  

 
 sudo  apt-get update
#  apt-get upgrade
 sudo apt-get install -y net-tools nc gpg







