#!/bin/bash
#
# uvdesk.sh
#
# This script is used to build gsa for GVM 
# 
# 
# 
#
# Authors:
#  Silas VIGAN <sisedaro05@yahoo.fr>
#
# 
cd /opt/gvm/src 
cd gsa ;\
 export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH ;\
 mkdir build ;\
 cd build/ ;\
 cmake -DCMAKE_INSTALL_PREFIX=/opt/gvm .. ;\
 make ;\
 make doc ;\
 make install ;\
 touch /opt/gvm/var/log/gvm/gsad.log ;\
 cd /opt/gvm/src
