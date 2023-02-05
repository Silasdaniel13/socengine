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
logfile=/opt/socengine/logs/zeek_$install_date.log
install_home=/opt/socengine/ZEEK/
post_install=./postinstall_zeek.sh

if (test -d $install_home);
then
	rm -r $install_home/*
else
	touch $logfile
	mkdir $install_home
fi

debian_version=Debian_11


####################################################
#            Installing Prerequisites              #
####################################################


cat <<BAN  
#################################################### 
#          Installing Zeek Prerequisites           #
####################################################
BAN

if (sudo apt-get install -y cmake curl gnupg2 make gcc g++ flex bison libpcap-dev libssl-dev python3 python3-dev swig zlib1g-dev python3-git python3-semantic-version);

then 

  echo "**************************************Tools installed successfully*****************"
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "**************************************Tools installed successfully*****************" >> $logfile
else 
  echo "**************************************Some Tools Have not been installed successfully*****************"
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "**************************************Some Tools Have not been installed successfully*****************" >> $logfile
  exit 0
fi 
    

####################################################
#               Installing Zeek                    #
####################################################

cat <<BAN  
#################################################### 
#          Installing Zeek Manually                #
####################################################
BAN
####Adding zeek repository 

sudo echo 'deb http://download.opensuse.org/repositories/security:/zeek/Debian_11/ /' | sudo tee /etc/apt/sources.list.d/zeek.list
curl -fsSL https://download.opensuse.org/repositories/security:zeek/Debian_11/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/security_zeek.gpg

echo "**************************************Zeek files  authentication key successfully downloaded*****************"
 
 echo $(date --rfc-3339=seconds) >> $logfile
 echo "**************************************Zeek files authentication key successfully downloaded*****************" >> $logfile

sudo apt update

sudo apt-cache policy zeek


if (sudo apt install -y zeek);
then
	echo "**************************************Zeek-lts successfully installed from apt package manager*****************"
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "**************************************Zeek-lts successfully installed from apt package manager*****************" >> $logfile
  echo "export PATH=$PATH:/opt/zeek/bin" | sudo tee /etc/profile.d/zeek.sh

  source /etc/profile.d/zeek.sh
else
  echo "**************************************Zeek-lts could not be successfully installed from apt package manager*****************"
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "**************************************Zeek-lts could not be successfully installed from apt package manager*****************" >> $logfile
  exit 0
fi



if (/opt/zeek/bin/zeekctl install);
then 
  echo "**************************************Zeekctl Service successfully installed*****************"
 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "**************************************Zeekctl Service successfully installed*****************" >> $logfile

 else
  echo "**************************************Zeekctl could not be successfully installed and restarted*****************"
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "**************************************Zeekctl could not be successfully installed and restarted*****************" >> $logfile
  exit 0
 fi 

exit 0
