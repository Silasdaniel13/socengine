#!/bin/bash
#
# uvdesk.sh
#
# This script is used to build gvm-libs
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
#      Download sources and Build Gvm-libs         #
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


##Setting GVM Version
export GVM_VERSION=22.4.0
export GVM_LIBS_VERSION=$GVM_VERSION

sudo apt install -y libglib2.0-dev libgpgme-dev libgnutls28-dev uuid-dev \
libssh-gcrypt-dev libhiredis-dev libxml2-dev libpcap-dev libnet1-dev libpaho-mqtt-dev \
libldap2-dev libradcli-dev cmake

curl -f -L https://github.com/greenbone/gvm-libs/archive/refs/tags/v$GVM_LIBS_VERSION.tar.gz -o $SOURCE_DIR/gvm-libs-$GVM_LIBS_VERSION.tar.gz
curl -f -L https://github.com/greenbone/gvm-libs/releases/download/v$GVM_LIBS_VERSION/gvm-libs-$GVM_LIBS_VERSION.tar.gz.asc -o $SOURCE_DIR/gvm-libs-$GVM_LIBS_VERSION.tar.gz.asc

tar -C $SOURCE_DIR -xvzf $SOURCE_DIR/gvm-libs-$GVM_LIBS_VERSION.tar.gz


#############Building gvm-libs

mkdir -p $BUILD_DIR/gvm-libs && cd $BUILD_DIR/gvm-libs

cmake $SOURCE_DIR/gvm-libs-$GVM_LIBS_VERSION \
  -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
  -DCMAKE_BUILD_TYPE=Release \
  -DSYSCONFDIR=/etc \
  -DLOCALSTATEDIR=/var

make -j$(nproc)

#####Installing gvm-libs¶


make DESTDIR=$INSTALL_DIR install

sudo cp -rv $INSTALL_DIR/* /

rm -rf $INSTALL_DIR/*