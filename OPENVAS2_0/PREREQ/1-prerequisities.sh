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


#####Setting Env Variables



cat << EOF >> ~/.bash_profile

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


EOF

source ~/.bash_profile

mkdir -p $SOURCE_DIR


mkdir -p $BUILD_DIR

mkdir -p $INSTALL_DIR




# Create the file repository configuration for Postgresql
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Import the repository signing key:
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Update the package lists:
sudo apt-get update

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


