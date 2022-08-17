#!/bin/bash
#
# uvdesk.sh
#
# This script is used to configure redis and set the permissions 
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
#   Redis configuration and permissions setting    #
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
######Installing Redis Server 

sudo apt install -y redis-server

#####Adding configuration for running the Redis server for the scanner

sudo cp $SOURCE_DIR/openvas-scanner-$GVM_VERSION/config/redis-openvas.conf /etc/redis/
sudo chown redis:redis /etc/redis/redis-openvas.conf
echo "db_address = /run/redis-openvas/redis.sock" | sudo tee -a /etc/openvas/openvas.conf

# start redis with openvas config
sudo systemctl start redis-server@openvas.service

# ensure redis with openvas config is started on every system startup
sudo systemctl enable redis-server@openvas.service


#####Adding the gvm user to the redis group

sudo usermod -aG redis gvm


#####Setting up the Mosquitto MQTT Broker

###The Mosquitto MQTT broker is used for communication between ospd-openvas, openvas-scanner and notus-scanner.
###Installing the Mosquitto broker

sudo apt install -y mosquitto


####After installing the Mosquitto broker package, the broker must be started and the server uri must be added to the openvas-scanner configuration.



##Starting the broker and adding the server uri to the openvas-scanner configuration


sudo systemctl start mosquitto.service
sudo systemctl enable mosquitto.service
echo "mqtt_server_uri = localhost:1883" | sudo tee -a /etc/openvas/openvas.conf







cat <<BAN  
####################################################
#               Adjusting Permissions              #
####################################################
BAN

####Adjusting Repository Permissions

sudo mkdir -p /var/lib/notus
sudo mkdir -p /run/gvmd

sudo chown -R gvm:gvm /var/lib/gvm
sudo chown -R gvm:gvm /var/lib/openvas
sudo chown -R gvm:gvm /var/lib/notus
sudo chown -R gvm:gvm /var/log/gvm
sudo chown -R gvm:gvm /run/gvmd

sudo chmod -R g+srw /var/lib/gvm
sudo chmod -R g+srw /var/lib/openvas
sudo chmod -R g+srw /var/log/gvm




#### To allow all users of the group gvm access to the postgres database via the various gvmd commands, 
#### The permissions of the gvmd executable will be adjusted to always run as the gvm user and under the gvm group.
####
####
#### Adjusting gvmd permissions


sudo chown gvm:gvm /usr/local/sbin/gvmd
sudo chmod 6750 /usr/local/sbin/gvmd

######Additionally the feed sync script permissions should be adjusted to only allow gvm user to execute them. Otherwise the permissions of the synced files will be broken.

###Adjusting feed sync script permissions

sudo chown gvm:gvm /usr/local/bin/greenbone-nvt-sync
sudo chmod 740 /usr/local/sbin/greenbone-feed-sync
sudo chown gvm:gvm /usr/local/sbin/greenbone-*-sync
sudo chmod 740 /usr/local/sbin/greenbone-*-sync


###Feed Validation

###Creating a GPG keyring for feed content validation

export GNUPGHOME=/tmp/openvas-gnupg
mkdir -p $GNUPGHOME

gpg --import /tmp/GBCommunitySigningKey.asc
gpg --import-ownertrust < /tmp/ownertrust.txt

export OPENVAS_GNUPG_HOME=/etc/openvas/gnupg
sudo mkdir -p $OPENVAS_GNUPG_HOME
sudo cp -r /tmp/openvas-gnupg/* $OPENVAS_GNUPG_HOME/
sudo chown -R gvm:gvm $OPENVAS_GNUPG_HOME

###Setting up sudo for Scanning
sudo visudo

...

# allow users of the gvm group run openvas
%gvm ALL = NOPASSWD: /usr/local/sbin/openvas