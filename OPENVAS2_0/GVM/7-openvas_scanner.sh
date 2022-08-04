#!/bin/bash
#
# uvdesk.sh
#
# This script is used to build Openvas Scanner
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
#   Download sources and Build Openvas scanner     #
####################################################
BAN

#######Setting the openvas-scanner version to use

export OPENVAS_SCANNER_VERSION=$GVM_VERSION


######Required dependancies

sudo apt install -y \
  bison \
  libglib2.0-dev \
  libgnutls28-dev \
  libgcrypt20-dev \
  libpcap-dev \
  libgpgme-dev \
  libksba-dev \
  rsync \
  nmap \
  libjson-glib-dev \
  libbsd-dev

######Optional dependencies for openvas-scanner

sudo apt install -y \
  python3-impacket \
  libsnmp-dev


#####Downloading the openvas-scanner sources

curl -f -L https://github.com/greenbone/openvas-scanner/archive/refs/tags/v$OPENVAS_SCANNER_VERSION.tar.gz -o $SOURCE_DIR/openvas-scanner-$OPENVAS_SCANNER_VERSION.tar.gz
curl -f -L https://github.com/greenbone/openvas-scanner/releases/download/v$OPENVAS_SCANNER_VERSION/openvas-scanner-$OPENVAS_SCANNER_VERSION.tar.gz.asc -o $SOURCE_DIR/openvas-scanner-$OPENVAS_SCANNER_VERSION.tar.gz.asc

##########Extracting source files
tar -C $SOURCE_DIR -xvzf $SOURCE_DIR/openvas-scanner-$OPENVAS_SCANNER_VERSION.tar.gz


#####Building openvas-scanner

mkdir -p $BUILD_DIR/openvas-scanner && cd $BUILD_DIR/openvas-scanner

cmake $SOURCE_DIR/openvas-scanner-$OPENVAS_SCANNER_VERSION \
  -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
  -DCMAKE_BUILD_TYPE=Release \
  -DSYSCONFDIR=/etc \
  -DLOCALSTATEDIR=/var \
  -DOPENVAS_FEED_LOCK_PATH=/var/lib/openvas/feed-update.lock \
  -DOPENVAS_RUN_DIR=/run/ospd

make -j$(nproc)



#######Installing Openvas-scanner
make DESTDIR=$INSTALL_DIR install

sudo cp -rv $INSTALL_DIR/* /

rm -rf $INSTALL_DIR/*
