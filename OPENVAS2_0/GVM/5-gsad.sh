#!/bin/bash
#
# uvdesk.sh
#
# This script is used to build gsad 
# The web server gsad is written in the C programming language. It serves static content 
# like images and provides an API for the web application. Internally it communicates with gvmd using GMP.
# 
# 
# 
#
# Authors:
# Silas VIGAN <sisedaro05@yahoo.fr>
#
# 

cat <<BAN  
####################################################
#      Download sources and Build GSAD             #
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



######Setting the GSAd version to use
export GSAD_VERSION=$GVM_VERSION

#######Required dependencies for gsad
sudo apt install -y \
  libmicrohttpd-dev \
  libxml2-dev \
  libglib2.0-dev \
  libgnutls28-dev


#######Downloading the gsad sources
curl -f -L https://github.com/greenbone/gsad/archive/refs/tags/v$GSAD_VERSION.tar.gz -o $SOURCE_DIR/gsad-$GSAD_VERSION.tar.gz
curl -f -L https://github.com/greenbone/gsad/releases/download/v$GSAD_VERSION/gsad-$GSAD_VERSION.tar.gz.asc -o $SOURCE_DIR/gsad-$GSAD_VERSION.tar.gz.asc

######Extracting the files

tar -C $SOURCE_DIR -xvzf $SOURCE_DIR/gsad-$GSAD_VERSION.tar.gz

#####Building Gsad

mkdir -p $BUILD_DIR/gsad && cd $BUILD_DIR/gsad

cmake $SOURCE_DIR/gsad-$GSAD_VERSION \
  -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
  -DCMAKE_BUILD_TYPE=Release \
  -DSYSCONFDIR=/etc \
  -DLOCALSTATEDIR=/var \
  -DGVMD_RUN_DIR=/run/gvmd \
  -DGSAD_RUN_DIR=/run/gsad \
  -DLOGROTATE_DIR=/etc/logrotate.d

make -j$(nproc)

######Installing gsad
make DESTDIR=$INSTALL_DIR install

sudo cp -rv $INSTALL_DIR/* /

rm -rf $INSTALL_DIR/*

