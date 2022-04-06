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
mkdir /var/ELK/
touch /var/ELK/log.txt

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

if sudo apt install -y default-jdk;
then
  
  echo JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64/" >> /etc/environment
  source /etc/environment

  echo "***********************************Open Jdk Installed successfully******************************"
  echo $(date --rfc-3339=seconds) > /var/ELK/log.txt
  echo "   ****************Open Jdk Installed successfully*********************" >> /var/ELK/log.txt

else
  echo "[ERROR]:  Installing Open Jdk FAILED " 
  echo $(date --rfc-3339=seconds) >> /var/ELK/log.txt
  echo "  [ERROR]: Installing Open Jdk FAILED " >> /var/ELK/log.txt  
fi  
####################################################
#        Installing  Elasticsearch 7.14.0          #
####################################################

cat <<BAN  
#################################################### 
#          Installing Elasticsearch 7.14.0         #
####################################################
BAN

if curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.14.0-amd64.deb;
then
  sudo dpkg -i elasticsearch-7.14.0-amd64.deb
  sudo mkdir /etc/systemd/system/elasticsearch.service.d
  echo -e "[Service]\nTimeoutStartSec=250" | sudo tee /etc/systemd/system/elasticsearch.service.d/startup-timeout.conf 
  sudo systemctl daemon-reload
  sudo systemctl enable elasticsearch
  sudo systemctl start elasticsearch
  echo "***********************************Elasticsearch Installed successfully******************************"
  echo $(date --rfc-3339=seconds) >> /var/ELK/log.txt
  echo "   ****************Elasticsearch Installed successfully*********************" >> /var/ELK/log.txt
else
  echo "[ERROR]: Installing Elasticsearch server FAILED" 
  echo $(date --rfc-3339=seconds) >> /var/ELK/log.txt
  echo "  [ERROR]: Installing Elasticsearch server FAILED " >> /var/ELK/log.txt  
fi



####################################################
#               Installing Kibana                  #
####################################################

cat <<BAN  
#################################################### 
#               Installing Kibana                  #
####################################################
BAN
apt-get install -y kibana
systemctl enable kibana
echo "***********************************Kibana successfully Installed******************************"
echo $(date --rfc-3339=seconds) >> /var/ELK/log.txt
echo "   ****************Kibana successfully Installed*********************" >> /var/UVDESK/log.txt



####################################################
#               Installing Logstash                #
####################################################

cat <<BAN  
#################################################### 
#          Installing Logstash                     #
####################################################
BAN

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

sudo apt-get install apt-transport-https

echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

sudo apt-get update 
if sudo apt-get install -y logstash;
then

  sudo systemctl start logstash.service
  echo "***********************************Logstash successfully Installed******************************"
  echo $(date --rfc-3339=seconds) >> /var/ELK/log.txt
  echo "   ****************Logstash successfully Installed*********************" >> /var/UVDESK/log.txt
else
  echo "[ERROR]: Installing Logstash server FAILED" 
  echo $(date --rfc-3339=seconds) >> /var/ELK/log.txt
  echo "  [ERROR]: Installing Logstash server FAILED " >> /var/ELK/log.txt  
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




