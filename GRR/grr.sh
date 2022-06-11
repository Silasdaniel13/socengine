#!/bin/bash
#
# grr.sh
#
# 
# Authors:
#  Silas VIGAN <sisedaro05@yahoo.fr>
#
# 

#VERSION=0.0.1
#HOST=$1
#PORT=${2:-443}
#sourcelist=./sources.list
#conf=./uvdesk.conf
install_home=/opt/socengine/GRR
install_date=$(date --rfc-3339=date)
logfile=/opt/socengine/logs/grr_$creating_date.log
mkdir $install_home
touch $logfile


grr_source="https://storage.googleapis.com/releases.grr-response.com/grr-server_3.4.5-1_amd64.deb"


grr_deb_file=grr-server_3.4.5-1_amd64.deb

####################################################
#            Installing GRR Server                 #
####################################################


cat <<BAN  
#################################################### 
#          Installing GRR SERVER                   #
####################################################

YOU WILL BE REQUIRED TO PROVIDE MySQL DATABASE CONNECTION INFORMATION

Just Follow the instruction
************************************************************************** 
BAN
apt-get install -y libssl$libssl_version
wget -P $install_home $grr_source
sudo apt install -y $install_home/$grr_deb_file


