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
logfile=/opt/socengine/logs/grr_preinstall_$creating_date.log
mkdir $install_home
touch $logfile
rootSqlPw="Test123"
password="Test123"

libssl_version=1.0.0
grr_source="https://storage.googleapis.com/releases.grr-response.com/grr-server_3.2.1-1_amd64.deb"
grr_deb_file=grr-server_3.2.1-1_amd64.deb
python_version=python3.6


#################################################
#     Installing Utils                          #
#################################################

apt-get install -y $python_version openssl python3-pip 
apt-get build-dep python-mysqldb

http://ftp.br.debian.org/debian/pool/main/p/python-mysqldb/python3-mysqldb_1.4.4-2+b3_amd64.deb
####################################################
#     Database creating and privilege granting     #
####################################################
  
if (  mysql -u root -p$rootSqlPw -e "CREATE DATABASE grr;");
then
	echo "**************************************GRR Database successfully created*****************"
 
 echo $(date --rfc-3339=seconds) >> $logfile
 echo "**************************************GRR Database successfully created*****************" >> $logfile 

else
	echo "**************************************GRR Database unsuccessfully created*****************"
 
 echo $(date --rfc-3339=seconds) >> $logfile
 echo "**************************************GRR Database unsuccessfully created*****************" >> $logfile 


fi 





 if (  mysql -u root -p$rootSqlPw -e "grant all privileges on grr.* to grr@$host identified by '$password';;" )
   
then
	echo "**************************************Privileges granted to GRR Database successfully*****************"
 
 echo $(date --rfc-3339=seconds) >> $logfile
 echo "**************************************Privileges granted to GRR Database successfully*****************" >> $logfile 

else
	echo "**************************************Privileges granted to GRR Database unsuccessfully*****************"
 
 echo $(date --rfc-3339=seconds) >> $logfile
 echo "**************************************Privileges granted to GRR Database unsuccessfully*****************" >> $logfile 


fi 
  
  
  
  
  
if  ( mysql -u root -p$rootSqlPw -e "FLUSH PRIVILEGES;" )
  
then
	echo "**************************************Privileges flush on GRR Database successfully*****************"
 
 echo $(date --rfc-3339=seconds) >> $logfile
 echo "**************************************Privileges flush on GRR Database successfully*****************" >> $logfile 

else
	echo "**************************************Privileges flush on GRR Database unsuccessfully*****************"
 
 echo $(date --rfc-3339=seconds) >> $logfile
 echo "**************************************Privileges flush on GRR Database unsuccessfully*****************" >> $logfile 


fi 
  


