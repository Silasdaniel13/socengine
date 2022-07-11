#!/bin/bash
#
# uvdesk.sh
#
# This script is used to download OpenVas Server Install Source Files on a Debian based server 
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

git clone -b stable --single-branch https://github.com/greenbone/gvm-libs.git

git clone -b main --single-branch https://github.com/greenbone/openvas-smb.git

git clone -b stable --single-branch https://github.com/greenbone/openvas.git

git clone -b stable --single-branch https://github.com/greenbone/ospd.git

git clone -b stable --single-branch https://github.com/greenbone/ospd-openvas.git

git clone -b stable --single-branch https://github.com/greenbone/gvmd.git

git clone -b stable --single-branch https://github.com/greenbone/gsa.git

git clone -b stable --single-branch https://github.com/greenbone/gsad.git