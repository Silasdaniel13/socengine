#!/bin/bash
#
# uvdesk.sh
#
# This script is used to create OpenVas Server Install Directories on a Debian based server 
#  
# 
# 
# 
#
# Authors:
#  Silas VIGAN <sisedaro05@yahoo.fr>
#
# 
mkdir /opt/gvm/src 
mkdir /opt/gvm/var
mkdir /opt/gvm/var/run
cd /opt/gvm/src ;\
export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH

