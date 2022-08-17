#!/bin/bash
#
# uvdesk.sh
#
# This script is used to build Openvas SMB
#  
# openvas-smb is a helper module for openvas-scanner. 
#It includes libraries (openvas-wmiclient/openvas-wincmd) to interface with Microsoft Windows Systems 
#through the Windows Management Instrumentation API and a winexe binary to execute processes remotely on that system.
#
#It is an optional dependency of openvas-scanner but is required for scanning Windows-based systems
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
#      Download sources and Build Openvas-smb      #
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

#######Required dependencies for openvas-smb
sudo apt install -y \
  gcc-mingw-w64 \
  libgnutls28-dev \
  libglib2.0-dev \
  libpopt-dev \
  libunistring-dev \
  heimdal-dev \
  perl-base


######Setting the openvas-smb version to use
export OPENVAS_SMB_VERSION=21.4.0

######Downloading the openvas-smb sources
curl -f -L https://github.com/greenbone/openvas-smb/archive/refs/tags/v$OPENVAS_SMB_VERSION.tar.gz -o $SOURCE_DIR/openvas-smb-$OPENVAS_SMB_VERSION.tar.gz
curl -f -L https://github.com/greenbone/openvas-smb/releases/download/v$OPENVAS_SMB_VERSION/openvas-smb-$OPENVAS_SMB_VERSION.tar.gz.asc -o $SOURCE_DIR/openvas-smb-$OPENVAS_SMB_VERSION.tar.gz.asc


#####Extracting the source
tar -C $SOURCE_DIR -xvzf $SOURCE_DIR/openvas-smb-$OPENVAS_SMB_VERSION.tar.gz

#####Building openvas-smb
mkdir -p $BUILD_DIR/openvas-smb && cd $BUILD_DIR/openvas-smb

cmake $SOURCE_DIR/openvas-smb-$OPENVAS_SMB_VERSION \
  -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
  -DCMAKE_BUILD_TYPE=Release

make -j$(nproc)


#######Installing openvas-smb

make DESTDIR=$INSTALL_DIR install

sudo cp -rv $INSTALL_DIR/* /

rm -rf $INSTALL_DIR/*