#!/bin/bash
#
# uvdesk.sh
#
# This script is used to build greenbone security assistant (gsa)
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
#      Download sources and Build GSA              #
####################################################
BAN

#######Setting the GSA version to use

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


export GSA_VERSION=$GVM_VERSION



###Install nodejs 14

export NODE_VERSION=node_14.x
export KEYRING=/usr/share/keyrings/nodesource.gpg
export DISTRIBUTION="$(lsb_release -s -c)"

curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | sudo tee "$KEYRING" >/dev/null
gpg --no-default-keyring --keyring "$KEYRING" --list-keys

echo "deb [signed-by=$KEYRING] https://deb.nodesource.com/$NODE_VERSION $DISTRIBUTION main" | sudo tee /etc/apt/sources.list.d/nodesource.list
echo "deb-src [signed-by=$KEYRING] https://deb.nodesource.com/$NODE_VERSION $DISTRIBUTION main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list


sudo apt update
sudo apt install -y nodejs


#####Install Yarn



curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt update
sudo apt install -y yarn

#######Downloading the gsa sources
curl -f -L https://github.com/greenbone/gsa/archive/refs/tags/v$GSA_VERSION.tar.gz -o $SOURCE_DIR/gsa-$GSA_VERSION.tar.gz
curl -f -L https://github.com/greenbone/gsa/releases/download/v$GSA_VERSION/gsa-$GSA_VERSION.tar.gz.asc -o $SOURCE_DIR/gsa-$GSA_VERSION.tar.gz.asc

#######Extracting the sources files

tar -C $SOURCE_DIR -xvzf $SOURCE_DIR/gsa-$GSA_VERSION.tar.gz

######Building gsa

cd $SOURCE_DIR/gsa-$GSA_VERSION

rm -rf build

yarn
yarn update
yarn build

######Installing gsa
sudo mkdir -p $INSTALL_PREFIX/share/gvm/gsad/web/
sudo cp -r build/* $INSTALL_PREFIX/share/gvm/gsad/web/