#!/bin/bash
#
# uvdesk.sh
#
# This script is used to install thehive project
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
#          Installing TheHive Project              #
####################################################
BAN
 ######## Prereq 
 
 cat <<BAN  
####################################################
#                Installing Openvas                #
####################################################
BAN

install_date=$(date --rfc-3339=date)
logfile=/opt/socengine/logs/openvas_$creating_date.log
install_home=/opt/socengine/THEHIVE/
Directory=`pwd`


echo ############################## Installing Java OpenJDK

wget -qO- https://apt.corretto.aws/corretto.key | sudo gpg --dearmor  -o /usr/share/keyrings/corretto.gpg
echo "deb [signed-by=/usr/share/keyrings/corretto.gpg] https://apt.corretto.aws stable main" |  sudo tee -a /etc/apt/sources.list.d/corretto.sources.list
sudo apt update

if (sudo apt install java-common java-11-amazon-corretto-jdk );	

then
	echo "**************************************OPENJDK successfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************OPENJDK successfully installed*****************" >> $logfile
else
	echo "**************************************OPENJDK unsuccessfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************OPENJDK unsuccessfully installed*****************" >> $logfile
	exit 0
fi


echo JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto" | sudo tee -a /etc/environment 




echo ############################## Installing Apache Cassandra

wget -qO -  https://downloads.apache.org/cassandra/KEYS | sudo gpg --dearmor  -o /usr/share/keyrings/cassandra-archive.gpg
echo "deb [signed-by=/usr/share/keyrings/cassandra-archive.gpg] https://downloads.apache.org/cassandra/debian 40x main" |  sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list 

sudo apt update

if (sudo apt install cassandra );	

then
	echo "**************************************Apache CASSANDRA successfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************Apache CASSANDRA successfully installed*****************" >> $logfile
else
	echo "**************************************Apache CASSANDRA unsuccessfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************Apache CASSANDRA unsuccessfully installed*****************" >> $logfile
	exit 0
fi


echo ################################ Installing The Hive

sudo mkdir -p /opt/thp/thehive/files


wget -O- https://archives.strangebee.com/keys/strangebee.gpg | sudo gpg --dearmor -o /usr/share/keyrings/strangebee-archive-keyring.gpg

echo 'deb [signed-by=/usr/share/keyrings/strangebee-archive-keyring.gpg] https://deb.strangebee.com thehive-5.x main' | sudo tee -a /etc/apt/sources.list.d/strangebee.list
sudo apt-get update

if (sudo apt-get install -y thehive );	

then
	echo "**************************************TheHive Project successfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************TheHive Project successfully installed*****************" >> $logfile
else
	echo "**************************************TheHive Project unsuccessfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************TheHive Project unsuccessfully installed*****************" >> $logfile
	exit 0
fi


chown -R thehive:thehive /opt/thp/thehive/files

sudo systemctl restart thehive

cat <<BAN  
########################################################
#       TheHive Project successfulled installed    
#       
#       Kindly log in at http://socengine:9000/
#       With the default credentials:
#        user: admin@thehive.local
#        password: secret
########################################################
BAN