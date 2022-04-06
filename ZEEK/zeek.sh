#!/bin/bash
#
# uvdesk.sh
#
# This script is used to install Zeek IDS on a Debian based server 
# Authors:
#  Silas VIGAN <sisedaro05@yahoo.fr>
#
# 


#sourcelist=./sources.list
#conf=./uvdesk.conf
mkdir /var/Zeek/
touch /var/Zeek/log.txt



####################################################
#            Installing Prerequisites              #
####################################################


cat <<BAN  
#################################################### 
#          Installing Zeek Prerequisites           #
####################################################
BAN

sudo apt-get install -y cmake make gcc g++ flex bison libpcap-dev libssl-dev python3 python3-dev swig zlib1g-dev 

sudo apt-get install -y python3-git python3-semantic-version


####################################################
#               Installing Zeek                    #
####################################################

cat <<BAN  
#################################################### 
#          Installing Zeek Manually                #
####################################################
BAN

echo 'deb http://download.opensuse.org/repositories/security:/zeek/Debian_10/ /' | sudo tee /etc/apt/sources.list.d/security:zeek.list
curl -fsSL https://download.opensuse.org/repositories/security:zeek/Debian_10/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/security_zeek.gpg > /dev/null
sudo apt update
sudo apt install zeek-lts
cd /opt/zeek/bin
./zeekctl install

