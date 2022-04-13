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
logfile=/opt/socenngine/logs/grr_$creating_date.log
mkdir $install_home
touch $logfile

libssl_version=1.0.0
grr_source="https://storage.googleapis.com/releases.grr-response.com/grr-server_3.2.1-1_amd64.deb"
grr_deb_file=grr-server_3.2.1-1_amd64.deb

####################################################
#              editing /etc/grr file               #
####################################################
  
  
  
####################################################
#              Restarting GRR Server               #
####################################################






#################################################################
#      Configuring Nginx to Run GRR UI behind HTTPS Proxy       #
#################################################################






####################################################
#              editing /etc/grr file               #
####################################################
  
  
  
   mysql -u root -p$rootSqlPw -e "CREATE DATABASE grr;" 
   mysql -u root -p$rootSqlPw -e "grant all privileges on grr.* to grr@$host identified by '$password';;"
   mysql -u root -p$rootSqlPw -e "FLUSH PRIVILEGES;"


