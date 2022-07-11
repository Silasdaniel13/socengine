#!/bin/bash
#
# uvdesk.sh
#
# This script is used to build gvmd 
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
cd gvmd ;\
 export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH ;\
 sed -i 's/POSTGRES=0/POSTGRES=1/g' tools/gvm-portnames-update.in ;\
 mkdir build ;\
 cd build/ ;\
 cmake -DCMAKE_INSTALL_PREFIX=/opt/gvm .. ;\
 make ;\
 make doc ;\
 make install ;\