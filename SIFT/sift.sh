#!/bin/bash
#
# suricata.sh
#
# 
# Authors:
#  Silas VIGAN <sisedaro05@yahoo.fr>
#
# 
mkdir /var/SIFT/
touch /var/SIFT/log.txt

####################################################
#              Checking the source list            #
####################################################
  

  apt-get update
  apt-get upgrade -y
  apt-get install -y curl

####################################################
#            Installing SIFT TOOLKIT               #
####################################################


cat <<BAN  
#################################################### 
#          Installing SIFT TOOLKIT                 #
####################################################
BAN
curl -Lo /usr/local/bin/sift https://github.com/sans-dfir/sift-cli/releases/download/v1.10.0/sift-cli-linux


curl -Lo /usr/local/bin/sift-cli-linux.sha256 https://github.com/sans-dfir/sift-cli/releases/download/v1.10.0/sift-cli-linux.sha256

curl -Lo /usr/local/bin/sift-cli-linux.sha256.asc https://github.com/sans-dfir/sift-cli/releases/download/v1.10.0/sift-cli-linux.sha256.asc

#cp ./suricata /etc/default/suricata

#Verification of the downloaded files
#apt-get install -y gnupg
#gpg --keyserver pgp.mit.edu --recv-keys 22598A94

#cp ./suricata.yaml /etc/suricata/suricata.yaml
#cp ./suricata.rules /etc/suricata/rules/suracata.rules




##################Update commands after editing some files 
#suricata-update
#suricata-update update-sources
#suricata-update enable-source oisf/trafficid
#suricata-update enable-source etnetera/aggressive
#suricata-update enable-source sslbl/ssl-fp-blacklist
#suricata-update enable-source et/open
#suricata-update enable-source tgreen/hunting
#suricata-update enable-source sslbl/ja3-fingerprints
#suricata-update enable-source ptresearch/attackdetection
#suricata-update

#systemctl enable suricata
#systemctl start suricata
