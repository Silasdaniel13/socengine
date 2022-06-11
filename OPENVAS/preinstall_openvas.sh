#!/bin/bash
#
# uvdesk.sh
#
# This script is used to install OpenVas Server on a Debian based server 
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
#            Installing Openvas utils              #
####################################################
BAN

install_date=$(date --rfc-3339=date)
logfile=/opt/socengine/logs/openvas_preinstall_$install_date.log
install_home=/opt/socengine/OPENVAS/
#install_file=./openvas.sh

if (test -d $install_home);
then
	rm -r $install_home/*
	touch $logfile
	mkdir $install_home
else
	touch $logfile
	mkdir $install_home
fi


conf=./systemd.txt
redis_conf=./redis.conf
gvm_home=/opt/gvm
gvm_source=$gvm_home/src


####################################################
#              Checking the source list            #
####################################################
  

  apt-get update
  


cat <<BAN  
####################################################
#            Installing Utils                      #
####################################################
BAN
sudo apt install -y software-properties-common ;\
sudo apt install -y cmake pkg-config libglib2.0-dev libgpgme-dev libgnutls28-dev uuid-dev libssh-gcrypt-dev \
libldap2-dev doxygen graphviz libradcli-dev libhiredis-dev libpcap-dev bison libksba-dev libsnmp-dev \
gcc-mingw-w64 heimdal-dev libpopt-dev xmltoman redis-server xsltproc libical-dev postgresql \
postgresql-contrib postgresql-server-dev-all gnutls-bin nmap rpm nsis curl wget fakeroot gnupg \
sshpass socat snmp smbclient libmicrohttpd-dev libxml2-dev python3-polib gettext rsync xml-twig-tools \
python3-paramiko python3-lxml python3-defusedxml python3-pip python3-psutil virtualenv vim git libunistring-dev;\


sudo apt install -y texlive-latex-extra --no-install-recommends ;\
sudo apt install -y texlive-fonts-recommended ;\
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - ;\
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list ;\
sudo apt update ;\
sudo apt -y install yarn




echo "**************************************Tools installed successfully*****************"

 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "**************************************Tools installed successfully*****************" >> $logfile
  
  
 if (id -u gvm > /dev/null 2>&1;);
 then
 	userdel -r gvm
 	echo "**************************************GVM USER SUCCESSFULLY REMOVED*****************"

 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "**************************************GVM USER SUCCESSFULLY REMOVED*****************" >> $logfile

fi


echo "**************************************PRE INSTALLATION OF OPENVAS SUCCESSFULLY EXECUTED*****************"

 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "***************************** PRE INSTALLATION OF OPENVAS SUCCESSFULLY EXECUTED **************************" >> $logfile


exit 0