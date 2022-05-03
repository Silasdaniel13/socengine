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
touch /var/ELK/credentials.txt
install_dir=$(pwd)
echo $install_dir
instance_file=$install_dir/instance.yml
temp=/home/olemboreelrichmond/tmp
echo $temp
host="http://elastic-siem:9200"
result_curl=$(curl http://elastic-siem:9200 | grep tagline | wc -l )

apt-get  install zip 

####################################################
#          Checking Elasticsearch service          #
####################################################
if [[ "$result_curl" == "1" ]];
then
  ES_HOME=/usr/share/elasticsearch
  ES_PATH_CONF=/etc/elasticsearch
  sudo mkdir $temp
  cd $temp
  mkdir cert_blog
  cd cert_blog
  cp $instance_file  ./
  pwd  
  ls ./

else
  echo "[SETUP_ERROR]:  Elasticsearch is not installed or not running on this server " 
  echo $(date --rfc-3339=seconds) >> /var/ELK/log.txt
  echo "[SETUP_ERROR]:  Elasticsearch is not installed or not running on this server "  >> /var/ELK/log.txt  
  exit 0
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
bin/elasticsearch-certutil cert --keep-ca-key --pem --in $temp/cert_blog/instance.yml --out $temp/cert_blog/certs.zip
cd $temp/cert_blog
unzip certs.zip -d ./certs


##############Elasticsearch TLS setup

cd $ES_PATH_CONF
mkdir certs
cp $temp/cert_blog/certs/ca/ca* $temp/cert_blog/certs/elastic/* certs

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

bin/elasticsearch-setup-passwords auto -u 'https://elastic-siem:9200' | tee $install_dir/credentials.txt



 
###########################Access _cat/nodes API via HTTPS
 curl --cacert $temp/cert_blog/certs/ca/ca.crt -u elastic 'https://elastic-siem:9200/_cat/nodes?v'
 
 
 
#########################Enable TLS for Kibana on srvsiem
 
 
 KIBANA_HOME=/usr/share/kibana
 KIBANA_PATH_CONFIG=/etc/kibana
 cd $temp/cert_blog/certs
 mkdir /etc/kibana/config/
  mkdir /etc/kibana/config/certs/
  cp -r $temp/cert_blog/certs/* /etc/kibana/config/certs/
  mv /etc/kibana/kibana.yml /etc/kibana/kibana.yml_backup
  cp $install_dir/kibana.yml /etc/kibana/kibana.yml

 Pass_kibana=$(cat $install_dir/credentials.txt | grep "PASSWORD kibana " |  awk -F' ' '{print $4}')
 echo "elasticsearch.password: "$Pass_kibana"" >>
 
 /usr/share/kibana/bin/kibana-encryption-keys generate | tail -n4 >> /etc/kibana/kibana.yml
 
 
 systemctl restart kibana
 
 
 
 
 

cat <<FIN  
#################################################### 
   ELK HAVE BEEN SUCCESSFULLY SECURED
   
    
####################################################
FIN


exit 0



