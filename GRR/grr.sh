#!/bin/bash
#
# grr.sh
#
# 
# Authors:
#  Silas VIGAN <sisedaro05@yahoo.fr>
#
# 

#VERSION=0.0.1
#HOST=$1
#PORT=${2:-443}
#sourcelist=./sources.list
#conf=./uvdesk.conf
mkdir /var/GRR/
touch /var/GRR/log.txt


####################################################
#              Checking the source list            #
####################################################
  
  echo "deb http://security.debian.org/debian-security jessie/updates main" >> /etc/apt/sources.list
  apt-get update
  apt-get upgrade -y


####################################################
#            Installing GRR Server                 #
####################################################


cat <<BAN  
#################################################### 
#          Installing GRR SERVER                   #
####################################################
BAN
apt-get install -y libssl1.0.0 
wget https://storage.googleapis.com/releases.grr-response.com/grr-server_3.2.1-1_amd64.deb

sudo apt install -y ./grr-server_3.2.1-1_amd64.deb

