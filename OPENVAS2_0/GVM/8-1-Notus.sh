#!/bin/bash
#
# uvdesk.sh
#
# This script is used to build notus scanner   
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
#   Download sources and Build notus scanner       #
####################################################
BAN
####Setting Notus Version to use

export NOTUS_VERSION=$GVM_VERSION

####Required DEpendencies for Notus

sudo apt install -y \
  python3-paho-mqtt \
  python3-psutil \
  python3-gnupg

###Downloading the notus-scanner sources

curl -f -L https://github.com/greenbone/notus-scanner/archive/refs/tags/v$NOTUS_VERSION.tar.gz -o $SOURCE_DIR/notus-scanner-$NOTUS_VERSION.tar.gz
curl -f -L https://github.com/greenbone/notus-scanner/releases/download/v$NOTUS_VERSION/notus-scanner-$NOTUS_VERSION.tar.gz.asc -o $SOURCE_DIR/notus-scanner-$NOTUS_VERSION.tar.gz.asc

###EXtracting files

tar -C $SOURCE_DIR -xvzf $SOURCE_DIR/notus-scanner-$NOTUS_VERSION.tar.gz

###Installing notus-scanner

cd $SOURCE_DIR/notus-scanner-$NOTUS_VERSION

python3 -m pip install . --prefix=$INSTALL_PREFIX --root=$INSTALL_DIR --no-warn-script-location

sudo cp -rv $INSTALL_DIR/* /

rm -rf $INSTALL_DIR/*

