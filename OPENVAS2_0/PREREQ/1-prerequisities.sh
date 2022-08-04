#!/bin/bash
#
# uvdesk.sh
#
# This script is used to set the prerequisities to GVM Build and Install
#  
# 
# 
# 
#
# Authors:
#  Silas VIGAN <sisedaro05@yahoo.fr>
#
# 
cat <<BAN  
####################################################
#          Prerequisities To GVM Building          #
####################################################
BAN

##Creating a user and group

sudo useradd -r -M -U -G sudo -s /usr/sbin/nologin gvm

echo "*****************User Successfully Added******************** "

##Adjusting the Current User

##Adding current user to gvm group
sudo usermod -aG gvm $USER




## Setting the path 
export PATH=$PATH:/usr/local/sbin

#####Choosing an Install Prefix
export INSTALL_PREFIX=/usr/local

###Creating a Source and Building Repository
export SOURCE_DIR=$HOME/source
mkdir -p $SOURCE_DIR


export BUILD_DIR=$HOME/build
mkdir -p $BUILD_DIR


export INSTALL_DIR=$HOME/install
mkdir -p $INSTALL_DIR


#######Installing common build dependencies
sudo apt update
sudo apt install --no-install-recommends --assume-yes \
  build-essential \
  curl \
  cmake \
  pkg-config \
  python3 \
  python3-pip \
  gnupg

##Importing the Greenbone Signing Key
curl -f -L https://www.greenbone.net/GBCommunitySigningKey.asc -o /tmp/GBCommunitySigningKey.asc
gpg --import /tmp/GBCommunitySigningKey.asc

##Setting GVM Version
export GVM_VERSION=22.4.0


