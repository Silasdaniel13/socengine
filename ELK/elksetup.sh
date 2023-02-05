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
logfile=/opt/socengine/logs/elksetup_$install_date.log
touch $logfile
install_home=/opt/socengine/ELK
credentials=$install_home/credentials.txt
if !(touch $credentials);
then
  echo "[ERROR]:  ELK Credentials file creating  FAILED " 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "  [ERROR]: ELK Credentials file creating FAILED" >> $logfile  
  exit 0
else
  echo "[OK]:  ELK Credentials file creating  Successful " 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "  [OK]: ELK Credentials file creating Successful" >> $logfile  
fi  

install_dir=$(pwd)
echo "The installing directory is: " $install_dir
instance_file=$install_dir/instance.yml
temp=$install_home/tmp
echo "The temp directory is: " $temp
host="http://elastic-siem:9200"
result_curl=$(curl http://elastic-siem:9200 | grep tagline | wc -l )
 

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
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "[SETUP_ERROR]:  Elasticsearch is not installed or not running on this server "  >> $logfile  
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
if !(bin/elasticsearch-certutil cert --keep-ca-key --pem --in $temp/cert_blog/instance.yml --out $temp/cert_blog/certs.zip);
then
  echo "[SETUP_ERROR]:  Certificates generating FAILED  " 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "[SETUP_ERROR]:  Certificates generating FAILED "  >> $logfile  
  exit 0
else
  echo "[SETUP_OK]:  Certificates generating Successful  " 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "[SETUP_OK]:  Certificates generating Successful "  >> $logfile  
  
fi
cd $temp/cert_blog
if (unzip certs.zip -d ./certs);
then
  echo "[SETUP_OK]:  Certificates deployment Successful  " 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "[SETUP_OK]:  Certificates deployment Successful "  >> $logfile  
else 
  echo "[SETUP_ERROR]:  Certificates deployment FAILED " 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "[SETUP_ERROR]:  Certificates generating FAILED "  >> $logfile 
  exit 0   
fi


##############Elasticsearch TLS setup

if (cd $ES_PATH_CONF);
then
  echo "[SETUP_OK]:  Accessing to ES Configuration Directory Successful  " 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "[SETUP_OK]:  Accessing to ES Configuration Directory Successful "  >> $logfile
else
  echo "[SETUP_ERROR]:  Accessing to ES Configuration Directory FAILED  " 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "[SETUP_ERROR]:  Accessing to ES Configuration Directory FAILED "  >> $logfile
  exit 0
fi

mkdir certs

if (cp $temp/cert_blog/certs/ca/ca* $temp/cert_blog/certs/elastic/* certs);
then
  echo "[SETUP_OK]:  Certificate files copying Successful  " 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "[SETUP_OK]:  Certificate files copying Successful "  >> $logfile
else
  echo "[SETUP_ERROR]:  Certificate files copying FAILED  " 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "[SETUP_ERROR]:  Certificate files copying FAILED "  >> $logfile
  exit 0
fi

#########Configure elasticsearch.yml
mv /etc/elasticsearch/elasticsearch.yml elasticsearch.yml_backup
if (cp $install_dir/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml);
then
  grep '\[elastic\] started' /var/log/elasticsearch/elasticsearch.log

  systemctl restart elasticsearch
  echo "[SETUP_OK]:  elasticsearch.yml file editing and configuring Successful  " 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "[SETUP_OK]:  elasticsearch.yml file editing and configuring Successful "  >> $logfile

else
  echo "[SETUP_ERROR]:  elasticsearch.yml file editing and configuring FAILED  " 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "[SETUP_ERROR]:  elasticsearch.yml file editing and configuring FAILED "  >> $logfile
  exit 0
fi

######################Setting built-in user password

cd $ES_HOME

cat <<BAN  
#----------------------------
     Please type 'Y' to confirm the password generation 

#----------------------
BAN

if (bin/elasticsearch-setup-passwords auto -u 'https://elastic-siem:9200' | tee $credentials );
then
  echo "[SETUP_OK]:  Elasticsearch Users Credentials  file creating Successful  " 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "[SETUP_OK]:  Elasticsearch Users Credentials  file creating Successful "  >> $logfile
else
	 echo "[SETUP_ERROR]:  elasticsearch.yml file editing and configuring FAILED  " 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "[SETUP_ERROR]:  elasticsearch.yml file editing and configuring FAILED "  >> $logfile
  exit 0
fi


 
###########################Access _cat/nodes API via HTTPS
 if (curl --cacert $temp/cert_blog/certs/ca/ca.crt -u elastic 'https://elastic-siem:9200/_cat/nodes?v');
 then
  echo "[SETUP_OK]:  Connecting to elasticsearch node Successful  " 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "[SETUP_OK]:  Connecting to elasticsearch node Successful "  >> $logfile
 else 
  echo "[SETUP_ERROR]:  Can not connect to elasticsearch node  " 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "[SETUP_ERROR]:  Can not connect to elasticsearch node "  >> $logfile
  exit 0
 fi
 
 
 
#########################Enable TLS for Kibana on srvsiem
 
 
 KIBANA_HOME=/usr/share/kibana
 KIBANA_PATH_CONFIG=/etc/kibana
 cd $temp/cert_blog/certs
 mkdir /etc/kibana/config/
  mkdir /etc/kibana/config/certs/
  
  if (cp -r $temp/cert_blog/certs/* /etc/kibana/config/certs/);
  then
    echo "[SETUP_OK]:  Kibana Certificate files copied to Kibana Config directory Successfuly  " 
    echo $(date --rfc-3339=seconds) >> $logfile
    echo "[SETUP_OK]:  Kibana Certificate files copied to Kibana Config directory Successfuly "  >> $logfile
  else
    echo "[SETUP_ERROR]:  Kibana Certificate files copy to Kibana Config directory Failed  " 
    echo $(date --rfc-3339=seconds) >> $logfile
    echo "[SETUP_ERROR]:  Kibana Certificate files copy to Kibana Config directory Failed "  >> $logfile
    exit 0
  fi

  mv /etc/kibana/kibana.yml /etc/kibana/kibana.yml_backup
  if (cp $install_dir/kibana.yml /etc/kibana/kibana.yml);
  then
    echo "[SETUP_OK]:  Kibana configuration file successfully set and edited   " 
    echo $(date --rfc-3339=seconds) >> $logfile
    echo "[SETUP_OK]:  Kibana configuration file successfully set and edited "  >> $logfile

  else
    echo "[SETUP_ERROR]:  Kibana configuration file unsuccessfully set and edited  " 
    echo $(date --rfc-3339=seconds) >> $logfile
    echo "[SETUP_ERROR]:  Kibana configuration file unsuccessfully set and edited "  >> $logfile
    exit 0

  fi

 Pass_kibana=$(cat $credentials | grep "PASSWORD kibana " |  awk -F' ' '{print $4}')
 echo "elasticsearch.password: "$Pass_kibana"" >> /etc/kibana/kibana.yml
 
 /usr/share/kibana/bin/kibana-encryption-keys generate | tail -n4 >> /etc/kibana/kibana.yml
 
 
 if (systemctl restart kibana);
 then
  

cat <<FIN  
#################################################### 
   ELK HAVE BEEN SUCCESSFULLY SECURED
   
    
####################################################
FIN
 
    echo $(date --rfc-3339=seconds) >> $logfile
    echo "[SETUP_OK]:  ELK HAVE BEEN SUCCESSFULLY SECURED "  >> $logfile
else
    echo "[SETUP_ERROR]:  ELK HAVE NOT BEEN SUCCESSFULLY SECURED  " 
    echo $(date --rfc-3339=seconds) >> $logfile
    echo "[SETUP_ERROR]:  ELK HAVE NOT BEEN SUCCESSFULLY SECURED "  >> $logfile
    exit 0

fi

exit 0



