#!/bin/bash
#
# suricata.sh
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
install_date=$(date --rfc-3339=date)
logfile=/opt/socengine/logs/suricata_$install_date.log
install_home=/opt/socengine/SURICATA/
touch $logfile
mkdir $install_home


####################################################
#              Checking the source list            #
####################################################
  

  apt-get update
  apt-get upgrade -y


####################################################
#            Installing Suricata IDS              #
####################################################


cat <<BAN  
#################################################### 
#          Installing Dependency packages          #
####################################################
BAN
apt-get install -y apt-utils 
if (apt-get install -y suricata);
then
  echo "[SURICATA_OK]**************************************Suricata Successfully installed*****************"
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "[SURICATA_OK]**************************************Suricata Successfully installed*****************" >> $logfile
else 
  echo "[SURICATA_ERROR]**************************************Suricata unsuccessfully installed*****************"
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "[SURICATA_ERROR]**************************************Suricata unsuccessfully installed*****************" >> $logfile
  exit 0
fi 

if (apt install -y python3-pip);
then
  
  pip3 install pyyaml
  pip3 install https://github.com/OISF/suricata-update/archive/master.zip
  pip3 install --pre --upgrade suricata-update

  cp ./suricata /etc/default/suricata
  cp ./suricata.yaml /etc/suricata/suricata.yaml
  cp ./suricata.rules /etc/suricata/rules/suracata.rules

  echo "[SURICATA_OK]**************************************Python Pip, suricata archive  Successfully installed and updated*****************"
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "[SURICATA_OK]**************************************Python Pip, suricata archive  Successfully installed and updated*****************" >> $logfile

else
  echo "[SURICATA_OK]**************************************Python Pip, suricata archive  Successfully installed and updated*****************"
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "[SURICATA_OK]**************************************Python Pip, suricata archive  Successfully installed and updated*****************" >> $logfile
  exit 0
fi






##################Update commands after editing some files 
suricata-update
suricata-update update-sources
suricata-update enable-source oisf/trafficid
suricata-update enable-source etnetera/aggressive
suricata-update enable-source sslbl/ssl-fp-blacklist
suricata-update enable-source et/open
suricata-update enable-source tgreen/hunting
suricata-update enable-source sslbl/ja3-fingerprints
suricata-update enable-source ptresearch/attackdetection
suricata-update

systemctl enable suricata
systemctl start suricata
