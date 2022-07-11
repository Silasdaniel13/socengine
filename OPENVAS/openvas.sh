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





####################"Create install dir"
sudo mkdir /opt/gvm ;\
sudo adduser gvm --disabled-password --home /opt/gvm/ --no-create-home --gecos '' ;\
sudo usermod -aG redis gvm  # This is for ospd-openvas can connect to redis.sock.. 
sudo chown gvm:gvm /opt/gvm/ ;\

#################Create source Directory
sudo /bin/su -c "$DIRECTORY/gvm/1-create_install_src.sh" - gvm			

#####################Downloading the sources to build
if (sudo /bin/su -c "$DIRECTORY/gvm/2-download_source.sh" - gvm);	

then
	echo "**************************************Downloadding GVM AND OPENVAS SOURCE FILE*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************Downloadding GVM AND OPENVAS SOURCE FILE*****************" >> $logfile
else
	echo "**************************************Downloadding GVM AND OPENVAS SOURCE FILE NOT SUCCESSFUL*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************Downloadding GVM AND OPENVAS SOURCE FILE NOT SUCCESSFUL*****************" >> $logfile
	exit 0
fi

######################install gvm-libs



if ( sudo /bin/su -c "$DIRECTORY/gvm/3-install_gvm-libs.sh" - gvm	);
then
  	echo "**************************************gvm-libs successfully compiled*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************gvm-libs successfully compiled*****************" >> $logfile
else
	echo "**************************************gvm-libs unsuccessfully compiled*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************gvm-libs unsuccessfully compiled*****************" >> $logfile
	exit 0
fi 
 cd $gvm_source

########################config and build openvas-smb

 if (sudo /bin/su -c "$DIRECTORY/gvm/4-build_openvas_smb.sh" - gvm);
 then
 	echo "**************************************openvas-smb successfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************openvas-smb successfully compiled*****************" >> $logfile
else
	echo "**************************************openvas-smb successfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************openvas-smb successfully compiled*****************" >> $logfile
	exit 0
fi 
 cd $gvm_source


###################config and build openvas scanner
if (sudo /bin/su -c "$DIRECTORY/gvm/5-build_openvas_scanner.sh" - gvm);
then
 	echo "**************************************openvas scanner successfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************openvas scanner successfully compiled*****************" >> $logfile
else
	echo "**************************************openvas scanner unsuccessfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************openvas scanner unsuccessfully compiled*****************" >> $logfile
	exit 0
fi 
 cd $gvm_source

################## Fix redis for default openvas install
sudo $DIRECTORY/root/8-fix-redis.sh





######################As openvas will be launched from an ospd-openvas process with sudo, the next configuration is required in the sudoers file:

#visudo

#########################Edit the secure_path line to this.

echo "Defaults        secure_path=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/opt/gvm/sbin\"" >> /etc/sudoers

######"Add this line to allow the created gvm user to launch openvas with root permissions.

### Allow the user running ospd-openvas, to launch openvas with root permissions
echo "gvm ALL = NOPASSWD: /opt/gvm/sbin/openvas" >> /etc/sudoers
echo "gvm ALL = NOPASSWD: /opt/gvm/sbin/gsad" >> /etc/sudoers


######Update NVT


if (sudo /bin/su -c "$DIRECTORY/gvm/7-update_nvt.sh" - gvm);
then
 	echo "**************************************NVT successfully updated*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************NVT successfully updated*****************" >> $logfile
else
	echo "**************************************NVT unsuccessfully updated*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************NVT unsuccessfully updated*****************" >> $logfile
	exit 0
fi

sudo openvas -u

################config and build GVMD

if (sudo /bin/su -c "$DIRECTORY/gvm/8-build_gvmd.sh" - gvm);
then
 	echo "**************************************GVM Manager successfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************GVM Manager successfully compiled*****************" >> $logfile
else
	echo "**************************************GVM Manager unsuccessfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************GVM Manager unsuccessfully compiled*****************" >> $logfile
	exit 0
fi 



################Configure PostgreSQL

sudo systemctl start postgresql.service
sudo /bin/su -c "$DIRECTORY/postgres/9-config_postgres.sh" - postgres

######fix certs
if (sudo /bin/su -c "$DIRECTORY/gvm/10-certs_and_user_create.sh" - gvm);
then
 	echo "**************************************Certificates  and user successfully configured*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************Certificates  and user successfully configured*****************" >> $logfile
else
	echo "**************************************Certificates  and user unsuccessfully configured*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************Certificates  and user unsuccessfully configured*****************" >> $logfile
	exit 0
fi 


###############configure and install gsa
if (sudo /bin/su -c "$DIRECTORY/gvm/11-build_gsa.sh" - gvm);
then
 	echo "**************************************GSA successfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************GSA successfully compiled*****************" >> $logfile
else
	echo "**************************************GSA unsuccessfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************GSA unsuccessfully compiled*****************" >> $logfile
	exit 0
fi 


###############OSPD-OPENVAS, the virtualenv and OSPD Install

if (sudo /bin/su -c "$DIRECTORY/gvm/12-ospd.sh" - gvm);
then
 	echo "**************************************OSPD and Virtualenv successfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************OSPD and Virtualenv successfully compiled*****************" >> $logfile
else
	echo "**************************************OSPD and Virtualenv unsuccessfully compiled*****************"
  	echo $(date --rfc-3339=seconds) >> $logfile
 	echo "**************************************OSPD and Virtualenv unsuccessfully compiled*****************" >> $logfile
	exit 0
fi 


################creating startupscripts
sudo $DIRECTORY/root/20-create-startup-scripts.sh

##########################Modify Default Scanners###############""""
CMD


su gvm << CMD

gvmd --get-scanners
gvmd --modify-scanner=08b69003-5fc2-4037-a479-93b440211c73 --scanner-host=/opt/gvm/var/run/ospd.sock

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
