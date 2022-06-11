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
logfile=/opt/socengine/logs/zeek_postinstall_$install_date.log
install_home=/opt/socengine/ZEEK/
node_config_file=/opt/zeek/etc/node.cfg
touch $logfile
server_host_name=$1
server_interface=$2




####################################################
#            Installing Prerequisites              #
####################################################


cat <<BAN  
#################################################### 
#         Zeek system files configuration          #
####################################################
BAN

echo "**************************************Zeek node file configuration started*****************"
 
 echo $(date --rfc-3339=seconds) >> $logfile
 echo "**************************************Zeek node file configuration started*****************" >> $logfile





/opt/zeek/bin/zeekctl stop

echo "**************************************Zeek service stopped to edit the config file*****************"
 
 echo $(date --rfc-3339=seconds) >> $logfile
 echo "**************************************Zeek service stopped to edit the config file*****************" >> $logfile



if (sed -i "s/^host=.*/host=$server_host_name/" $node_config_file);

then
	echo "**************************************Zeek hostname successfully updated*****************"
 
 echo $(date --rfc-3339=seconds) >> $logfile
 echo "**************************************Zeek hostname successfully updated*****************" >> $logfile

else
	echo "**************************************Zeek hostname unsuccessfully updated*****************"
 
 echo $(date --rfc-3339=seconds) >> $logfile
 echo "**************************************Zeek hostname unsuccessfully updated*****************" >> $logfile
fi



if (sed -i 's/^interface=.*/interface='"$server_interface"'/' $node_config_file);
then
	echo "**************************************Zeek server interface successfully updated*****************"
 
 echo $(date --rfc-3339=seconds) >> $logfile
 echo "**************************************Zeek server interface successfully updated*****************" >> $logfile

else
	echo "**************************************Zeek server interface unsuccessfully updated*****************"
 
 echo $(date --rfc-3339=seconds) >> $logfile
 echo "**************************************Zeek server interface unsuccessfully updated*****************" >> $logfile
fi
	
if (/opt/zeek/bin/zeekctl start);
then

echo "**************************************Zeek service started successfullye*****************"
 
 echo $(date --rfc-3339=seconds) >> $logfile
 echo "**************************************Zeek service started successfullye*****************" >> $logfile
else
echo "**************************************Zeek service started successfullye*****************"
 
 echo $(date --rfc-3339=seconds) >> $logfile
 echo "**************************************Zeek service started successfullye*****************" >> $logfile
 fi


exit 0
