#!/bin/bash
#
# uvdesk.sh
#
# This script is used to install MQTT on debian based Systems
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
#          Prerequisities To MQTT library         #
####################################################
BAN

sudo apt-get install build-essential gcc make cmake cmake-gui cmake-curses-gui

sudo apt-get install fakeroot fakeroot devscripts dh-make lsb-release

sudo apt-get install libssl-dev

sudo apt-get install doxygen graphviz


git clone https://github.com/eclipse/paho.mqtt.c.git

cd paho.mqtt.c

make
sudo make install

make html
