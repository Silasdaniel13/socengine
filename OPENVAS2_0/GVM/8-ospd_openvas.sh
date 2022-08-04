#!/bin/bash
#
# uvdesk.sh
#
# This script is used to build ospd-openvas   
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
#   Download sources and Build ospd-openvas        #
####################################################
BAN

#######Setting the ospd and ospd-openvas versions to use
export OSPD_OPENVAS_VERSION=$GVM_VERSION


######Required dependencies for ospd-openvas
sudo apt install -y \
  python3 \
  python3-pip \
  python3-setuptools \
  python3-packaging \
  python3-wrapt \
  python3-cffi \
  python3-psutil \
  python3-lxml \
  python3-defusedxml \
  python3-paramiko \
  python3-redis \
  python3-paho-mqtt

#########Downloading the ospd-openvas sources

curl -f -L https://github.com/greenbone/ospd-openvas/archive/refs/tags/v$OSPD_OPENVAS_VERSION.tar.gz -o $SOURCE_DIR/ospd-openvas-$OSPD_OPENVAS_VERSION.tar.gz
curl -f -L https://github.com/greenbone/ospd-openvas/releases/download/v$OSPD_OPENVAS_VERSION/ospd-openvas-$OSPD_OPENVAS_VERSION.tar.gz.asc -o $SOURCE_DIR/ospd-openvas-$OSPD_OPENVAS_VERSION.tar.gz.asc

#####Extract downloaded sources

tar -C $SOURCE_DIR -xvzf $SOURCE_DIR/ospd-openvas-$OSPD_OPENVAS_VERSION.tar.gz

#####Installing ospd-openvas

cd $SOURCE_DIR/ospd-openvas-$OSPD_OPENVAS_VERSION

python3 -m pip install . --prefix=$INSTALL_PREFIX --root=$INSTALL_DIR --no-warn-script-location

sudo cp -rv $INSTALL_DIR/* /

rm -rf $INSTALL_DIR/*

