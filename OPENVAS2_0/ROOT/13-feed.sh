#!/bin/bash
#
# uvdesk.sh
#
# This script is used to configure and sync the feed
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
#             Feed configure and sync              #
####################################################
BAN

####Certain resources that were previously part of 
###the gvmd source code are now shipped via the feed. An example is the scan configuration “Full and Fast”

###Setting the Feed Import Owner

gvmd --modify-setting 78eceaec-3385-11ea-b237-28d24461215b --value `gvmd --get-users --verbose | grep admin | awk '{print $2}'`

###Syncing VTs processed by the scanner

sudo -u gvm greenbone-nvt-sync

###Syncing the data processed by gvmd

sudo -u gvm greenbone-feed-sync --type SCAP
sudo -u gvm greenbone-feed-sync --type CERT
sudo -u gvm greenbone-feed-sync --type GVMD_DATA
