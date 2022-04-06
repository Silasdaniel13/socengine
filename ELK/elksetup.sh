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
#mkdir /var/ELK/
touch /var/ELK/credentials.txt
install_dir=$(pwd)
instance_file=$install_dir/instance.yml
temp=~/tmp/

####################################################
#          Checking Elasticsearch service          #
####################################################
if [$(curl http://127.0.0.1:9200 | grep tagline | wc -l ) == 1 ]
then
  ES_HOME=/usr/share/elasticsearch
  ES_PATH_CONF=/etc/elasticsearch
  mkdir $temp
  cd $temp
  mkdir cert_blog
  cd cert_blog
  cp $instance_file  ./
else
  echo "[SETUP_ERROR]:  Elasticsearch is not installed or not running on this server " 
  echo $(date --rfc-3339=seconds) >> /var/ELK/log.txt
  echo "[SETUP_ERROR]:  Elasticsearch is not installed or not running on this server "  >> /var/ELK/log.txt  
fi

####################################################
#              Securing ELK Stack                  #
####################################################



cat <<BAN  
####################################################
#              Securing ELK Stack                  #
####################################################
BAN
####################Generating and installing Certificate

cd $ES_HOME
bin/elasticsearch-certutil cert --keep-ca-key --pem --in ~/tmp/cert_blog/instance.yml --out ~/tmp/cert_blog/certs.zip
cd ~/tmp/cert_blog
unzip certs.zip -d ./certs


##############Elasticsearch TLS setup

cd $ES_PATH_CONF
mkdir certs
cp ~/tmp/cert_blog/certs/ca/ca* ~/tmp/cert_blog/certs/elastic/* certs

#########Configure elasticsearch.yml
mv /etc/elasticsearch/elasticsearch.yml elasticsearch.yml_backup
cp $install_dir/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
grep '\[elastic\] started' /var/log/elasticsearch/elasticsearch.log

systemctl restart elasticsearch

######################Setting built-in user password

cd $ES_HOME

cat <<BAN  
#----------------------------
     Please type 'Y' to confirm the password generation 

#----------------------
BAN

bin/elasticsearch-setup-passwords auto -u 'https://srvsiem.local:9200' | tee /var/ELK/credentials.txt



 
###########################Access _cat/nodes API via HTTPS
 curl --cacert ~/tmp/cert_blog/certs/ca/ca.crt -u elastic 'https://srvsiem:9200/_cat/nodes?v'
 
 
 
#########################Enable TLS for Kibana on srvsiem
 
 
 KIBANA_HOME=/usr/share/kibana
 KIBANA_PATH_CONFIG=/etc/kibana
 cd ~/tmp/cert_blog/certs
 mkdir /etc/kibana/config/
  mkdir /etc/kibana/config/certs/
  cp ~/tmp/cert_blog/certs/* /etc/kibana/config/certs/
  mv /etc/kibana/kibana.yml /etc/kibana/kibana.yml_backup
  cp ./kibana.yml /etc/kibana/kibana.yml

 Pass_kibana=$(cat /var/ELK/credentials.txt | grep "PASSWORD kibana " |  awk -F' ' '{print $4}')
 echo "elasticsearch.password: "$Pass_kibana"" >>
 
 /usr/share/kibana/bin/kibana-encryption-keys generate | tail -n4 >> /etc/kibana/kibana.yml
 
 
 systemctl restart kibana
 
 
 
 
 
 
 



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
   ELK HAVE BEEN SUCCESSFULLY SECURED
   
    
####################################################
FIN


exit 0




