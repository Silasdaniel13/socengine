#!/bin/bash
#
# uvdesk.sh
#
# This script is used to install gvm-tools  
#  
# 
# 
#
#  Authors:
#  Silas VIGAN <sisedaro05@yahoo.fr>
#
# 
#
cat <<BAN  
####################################################
#   Download sources and install gvm-tools         #
####################################################
BAN

## Setting the path 
export PATH=$PATH:/usr/local/sbin

#####Choosing an Install Prefix
export INSTALL_PREFIX=/usr/local

###Creating a Source and Building Repository
export SOURCE_DIR=$HOME/source


export BUILD_DIR=$HOME/build



export INSTALL_DIR=$HOME/install

#####Required tools to install gvm-tools

sudo apt install -y \
  python3 \
  python3-pip \
  python3-setuptools \
  python3-packaging \
  python3-lxml \
  python3-defusedxml \
  python3-paramiko

#####Installing gvm-tools for the current user

python3 -m pip install --upgrade pip
python3 -m pip install --user gvm-tools

######Installing gvm-tools system-wide
python3 -m pip install --prefix=$INSTALL_PREFIX --root=$INSTALL_DIR --no-warn-script-location gvm-tools

sudo cp -rv $INSTALL_DIR/* /

rm -rf $INSTALL_DIR/*
