#!/bin/bash
#
# uvdesk.sh
#
# This script is used to install ELK SIEM on a Debian based server 
# To do so we will need to set up 
# Java OpenJDK
# Elasticsearch
# Logstash
# Kibana
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

install_date=$(date --rfc-3339=date)
logfile=/opt/socengine/logs/elk_$install_date.log
install_home=/opt/socengine/ELK/
touch $logfile
mkdir $install_home
jdk_version=openjdk-11-jdk

####################################################
#              Checking Update                     #
####################################################
  
apt-get update
apt-get upgrade -y

####################################################
#            Installing OpenJDK 11                 #
####################################################



cat <<BAN  
#################################################### 
#          Installing OPenJDK 11                   #
####################################################
BAN

if sudo apt install -y $jdk_version;
then
  
  echo JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64/" >> /etc/environment
  source /etc/environment

  echo "***********************************Open Jdk Installed successfully******************************"
  echo $(date --rfc-3339=seconds) > $logfile
  echo "   ****************Open Jdk Installed successfully*********************" >> $logfile

else
  echo "[ERROR]:  Installing Open Jdk FAILED " 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "  [ERROR]: Installing Open Jdk FAILED " >> $logfile  
  exit 0
fi  
####################################################
#        Installing  Elasticsearch 7.14.0          #
####################################################

cat <<BAN  
#################################################### 
#          Installing Elasticsearch 7.14.0         #
####################################################
BAN

if wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - ;
then
  sudo apt-get install apt-transport-https
  echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
  sudo apt-get update -y 
  sudo apt-get install  -y elasticsearch
  
  sudo mkdir /etc/systemd/system/elasticsearch.service.d
  echo -e "[Service]\nTimeoutStartSec=400" | sudo tee /etc/systemd/system/elasticsearch.service.d/startup-timeout.conf 
  sudo systemctl daemon-reload
  sudo systemctl enable elasticsearch
  sudo systemctl start elasticsearch
  echo "***********************************Elasticsearch Installed successfully******************************"
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "   ****************Elasticsearch Installed successfully*********************" >> $logfile
else
  echo "[ERROR]: Installing Elasticsearch server FAILED" 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "  [ERROR]: Installing Elasticsearch server FAILED " >> $logfile  
  exit 0
fi



####################################################
#               Installing Kibana                  #
####################################################

cat <<BAN  
#################################################### 
#               Installing Kibana                  #
####################################################
BAN
if sudo apt-get install -y kibana
then
 
  systemctl enable kibana
  sudo systemctl start kibana 
  echo "***********************************Kibana successfully Installed******************************"
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "   ****************Kibana successfully Installed*********************" >> $logfile
else
  echo "[ERROR]: Installing Kibana server FAILED" 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "  [ERROR]: Installing Kibana server FAILED " >> $logfile 
  exit 0 
fi


####################################################
#               Installing Logstash                #
####################################################

cat <<BAN  
#################################################### 
#          Installing Logstash                     #
####################################################
BAN


if sudo apt-get install -y logstash;
then

  sudo systemctl start logstash.service
  echo "***********************************Logstash successfully Installed******************************"
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "   ****************Logstash successfully Installed*********************" >> $logfile
else
  echo "[ERROR]: Installing Logstash server FAILED" 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "  [ERROR]: Installing Logstash server FAILED " >> $logfile  
  exit 0
fi


cat <<BAN  
#################################################### 
#            Installing  Metricbeat                #
####################################################
BAN


apt-get install -y metricbeat


######################To set up the system module and start collecting system metrics

sudo metricbeat modules enable system

sudo metricbeat setup -e

sudo service metricbeat start

cat <<FIN  
#################################################### 
   ELK HAVE BEEN SUCCESSFULLY INSTALLED
   
    
####################################################
FIN


exit 0



