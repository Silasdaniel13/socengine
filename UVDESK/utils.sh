#!/bin/bash
#
# uvdesk.sh
#
# This script is used to install Useful tools  
#
#
# Authors:
#  Silas VIGAN <sisedaro05k@yahoo.fr>
#
# 
sourcelist=./sources.list

####################################################
#              Checking the source list            #
####################################################
  
if test -f "$sourcelist";
then 
  cat ./sources.list >> /etc/apt/sources.list
  apt-get update
  apt-get upgrade
  apt-get install -y net-tools nc
else
  echo "[ERROR]: Source file missing in the script directory" 
  exit 0 
fi


