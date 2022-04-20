#!/bin/bash
#
# uvdesk.sh
#
# This script is used to install Zeek IDS on a Debian based server 
# Authors:
#  Silas VIGAN <sisedaro05@yahoo.fr>
#
# 


#sourcelist=./sources.list
#conf=./uvdesk.conf

install_date=$(date --rfc-3339=date)
logfile=/opt/socengine/logs/zeek_$creating_date.log
install_home=/opt/socengine/ZEEK/
post_install=./postinstall_zeek.sh

if (test -d $install_home);
then
	rm -r $install_home/*
else
	touch $logfile
	mkdir $install_home
fi

debian_version=Debian_10





####################################################
#            Installing Prerequisites              #
####################################################


cat <<BAN  
#################################################### 
#          Installing Zeek Prerequisites           #
####################################################
BAN

sudo apt-get install -y cmake make gcc g++ flex bison libpcap-dev libssl-dev python3 python3-dev swig zlib1g-dev 

echo "**************************************Tools installed successfully*****************"

 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "**************************************Tools installed successfully*****************" >> $logfile
  
  
sudo apt-get install -y python3-git python3-semantic-version

echo "**************************************Python successfully installed*****************"

 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "**************************************Python successfully installed*****************" >> $logfile
  

####################################################
#               Installing Zeek                    #
####################################################

cat <<BAN  
#################################################### 
#          Installing Zeek Manually                #
####################################################
BAN

echo 'deb http://download.opensuse.org/repositories/security:/zeek/Debian_10/ /' | sudo tee /etc/apt/sources.list.d/security:zeek.list
curl -fsSL https://download.opensuse.org/repositories/security:zeek/Debian_10/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/security_zeek.gpg > /dev/null

echo "**************************************Zeek installing files successfully downloaded*****************"
 
 echo $(date --rfc-3339=seconds) >> $logfile
 echo "**************************************Zeek installing files successfully downloaded*****************" >> $logfile

sudo apt update


if (sudo apt install zeek-lts);
then
	echo "**************************************Zeek installing files     successfully downloaded*****************"
 
        echo $(date --rfc-3339=seconds) >> $logfile
        echo "**************************************Zeek installing files successfully downloaded*****************" >> $logfile
fi



/opt/zeek/bin/zeekctl install
echo "**************************************Zeekctl Service successfully installed*****************"
 
 echo $(date --rfc-3339=seconds) >> $logfile
 echo "**************************************Zeekctl Service successfully installed*****************" >> $logfile

 

exit 0
