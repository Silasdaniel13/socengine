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

#VERSION=0.0.1
#HOST=$1
#PORT=${2:-443}
#sourcelist=./sources.list



cat <<BAN  
####################################################
#                Installing Openvas                #
####################################################
BAN

install_date=$(date --rfc-3339=date)
logfile=/opt/socengine/logs/openvas_$creating_date.log
install_home=/opt/socengine/OPENVAS/
#install_file=./openvas.sh
Directory=`pwd`
conf=./systemd.txt
redis_conf=./redis.conf
gvm_home=/opt/gvm
gvm_source=/opt/gvm/src





#################Install Prerequisities
sudo $DIRECTORY/PREREQ/1-prerequisities.sh 			

#####################Install GVM LIBS
if (sudo $DIRECTORY/GVM/2-gvm_libs.sh );	

then
	echo "**************************************GVM LIBS successfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************GVM LIBS successfully installed*****************" >> $logfile
else
	echo "**************************************GVM LIBS unsuccessfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************GVM LIBS unsuccessfully installed*****************" >> $logfile
	exit 0
fi

######################install gvmd



if ( sudo $DIRECTORY/GVM/3-gvmd.sh	);
then
  	echo "**************************************gvmd successfully compiled*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************gvmd successfully compiled*****************" >> $logfile
else
	echo "**************************************gvmd unsuccessfully compiled*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************gvmd unsuccessfully compiled*****************" >> $logfile
	exit 0
fi 
 

########################config and build pg-gvm

 if (sudo $DIRECTORY/GVM/3-1-pg_gvm.sh);
 then
 	echo "**************************************pg-gvm successfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************pg-gvm successfully compiled*****************" >> $logfile
else
	echo "**************************************pg-gvm successfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************pg-gvm successfully compiled*****************" >> $logfile
	exit 0
fi 


###################config and build gsa
if (sudo $DIRECTORY/GVM/4-gsa.sh);
then
 	echo "**************************************gsa successfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************gsa successfully compiled*****************" >> $logfile
else
	echo "**************************************gsa unsuccessfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************gsa unsuccessfully compiled*****************" >> $logfile
	exit 0
fi 
 cd $gvm_source





###################config and build gsad
if (sudo $DIRECTORY/GVM/5-gsad.sh);
then
 	echo "**************************************gsad successfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************gsad successfully compiled*****************" >> $logfile
else
	echo "**************************************gsad unsuccessfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************gsad unsuccessfully compiled*****************" >> $logfile
	exit 0
fi 
 cd $gvm_source




 ###################config and build openvas SMB
if (sudo $DIRECTORY/GVM/6-Openvas_smb.sh);
then
 	echo "**************************************gsa successfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************gsa successfully compiled*****************" >> $logfile
else
	echo "**************************************gsa unsuccessfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************gsa unsuccessfully compiled*****************" >> $logfile
	exit 0
fi 
 


 ###################config and build openvas-scanner 
if (sudo $DIRECTORY/GVM/7-openvas_scanner.sh);
then
 	echo "**************************************openvas-scanner successfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************openvas-scanner successfully compiled*****************" >> $logfile
else
	echo "**************************************openvas-scanner unsuccessfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************openvas-scanner unsuccessfully compiled*****************" >> $logfile
	exit 0
fi 
 





 ###################config and build ospd-openvas.sh
if (sudo $DIRECTORY/GVM/8-ospd_openvas.sh);
then
 	echo "**************************************ospd-openvas.sh successfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************ospd-openvas.sh successfully compiled*****************" >> $logfile
else
	echo "**************************************ospd-openvas.sh unsuccessfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************ospd-openvas.sh unsuccessfully compiled*****************" >> $logfile
	exit 0
fi 




 ###################config and build gvm tools
if (sudo $DIRECTORY/GVM/9-gvm_tools.sh);
then
 	echo "**************************************gvm tools successfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************gvm tools successfully compiled*****************" >> $logfile
else
	echo "**************************************gvm tools unsuccessfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************gvm tools unsuccessfully compiled*****************" >> $logfile
	exit 0
fi 




 ###################Permission Setup
if (sudo $DIRECTORY/ROOT/10-setup-permission.sh);
then
 	echo "**************************************Permissions successfully configured*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************Permissions successfully configured*****************" >> $logfile
else
	echo "**************************************Permissions unsuccessfully configured*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************Permissions unsuccessfully configured*****************" >> $logfile
	exit 0
fi 
 



 ###################config Postgres database
if (sudo $DIRECTORY/PGSQL/11-postgres.sh);
then
 	echo "**************************************Postgres database successfully configured*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************Postgres database successfully configured*****************" >> $logfile
else
	echo "**************************************Postgres database unsuccessfully configured*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************Postgres database unsuccessfully configured*****************" >> $logfile
	exit 0
fi 
 cd $gvm_source





 ###################Creating username
if (sudo $DIRECTORY/PGSQL/12-create_user.sh);
then
 	echo "**************************************username successfully created*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************username successfully created*****************" >> $logfile
else
	echo "**************************************username unsuccessfully created*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************username unsuccessfully created*****************" >> $logfile
	exit 0
fi 
 


 ###################Feed configuration and synchronization
if (sudo $DIRECTORY/ROOT/13-feed.sh);
then
 	echo "**************************************Feed configuration and synchronization successful *****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************Feed configuration and synchronization successful *****************" >> $logfile
else
	echo "**************************************Feed configuration and synchronization unsuccessful *****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************Feed configuration and synchronization unsuccessful *****************" >> $logfile
	exit 0
fi 
 

 ###################Feed configuration and synchronization
if (sudo $DIRECTORY/ROOT/13-feed.sh);
then
 	echo "**************************************Feed configuration and synchronization successful *****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************Feed configuration and synchronization successful *****************" >> $logfile
else
	echo "**************************************Feed configuration and synchronization unsuccessful *****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************Feed configuration and synchronization unsuccessful *****************" >> $logfile
	exit 0
fi 
 

 ###################Startup Script
if (sudo $DIRECTORY/ROOT/14-startup.sh);
then
 	echo "**************************************Startup Script successful *****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************Startup Script successful *****************" >> $logfile
else
	echo "**************************************Startup Script unsuccessful *****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************Startup Script unsuccessful *****************" >> $logfile
	exit 0
fi 
 



cat <<BAN  
#################################################### 
        Installation Successfully done
    Login to the Web interface by https://your_ip
    Login: admin
    Password: admin  

####################################################
BAN
CMD

exit 0
