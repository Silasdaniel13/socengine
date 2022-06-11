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



#Verification of the downloaded files
apt-get install -y gnupg
gpg --keyserver pgp.mit.edu --recv-keys 22598A94






