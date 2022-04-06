#!/bin/bash
#
# suricata.sh
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
mkdir /var/SURICATA/
touch /var/SURICATA/log.txt

####################################################
#              Checking the source list            #
####################################################
  

  apt-get update
  apt-get upgrade -y


####################################################
#            Installing Suricata IDS              #
####################################################


cat <<BAN  
#################################################### 
#          Installing Dependency packages          #
####################################################
BAN
apt-get install -y apt-utils 
apt-get install -y suricata
apt install -y python3-pip
pip3 install pyyaml
pip3 install https://github.com/OISF/suricata-update/archive/master.zip
pip3 install --pre --upgrade suricata-update


cp ./suricata /etc/default/suricata
cp ./suricata.yaml /etc/suricata/suricata.yaml
cp ./suricata.rules /etc/suricata/rules/suracata.rules




##################Update commands after editing some files 
suricata-update
suricata-update update-sources
suricata-update enable-source oisf/trafficid
suricata-update enable-source etnetera/aggressive
suricata-update enable-source sslbl/ssl-fp-blacklist
suricata-update enable-source et/open
suricata-update enable-source tgreen/hunting
suricata-update enable-source sslbl/ja3-fingerprints
suricata-update enable-source ptresearch/attackdetection
suricata-update

systemctl enable suricata
systemctl start suricata
