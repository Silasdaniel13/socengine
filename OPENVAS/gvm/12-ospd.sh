#!/bin/bash
#
# uvdesk.sh
#
# This script is used to generate certificates and create the admin user
#  
# 
# 
# 
#
# Authors:
#  Silas VIGAN <sisedaro05@yahoo.fr>
#
# 
cd /opt/gvm/src 
###############OSPD-OPENVAS-----install the virtualenv

cd /opt/gvm/src ;\
export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH ;\
virtualenv --python python3.7  /opt/gvm/bin/ospd-scanner/ ;\
source /opt/gvm/bin/ospd-scanner/bin/activate

#########install ospd

mkdir /opt/gvm/var/run/ospd/ ;\
cd ospd ;\
pip3 install . ;\
cd /opt/gvm/src

#####################install ospd-openvas
cd ospd-openvas ;\
pip3 install . ;\
cd /opt/gvm/src
