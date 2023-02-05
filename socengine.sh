#!/bin/bash
#
# 
#
# This script is used to install the socengine tools. It's the first version be kind if i doesn't work as expected.
# We will be working on a better version.
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


cat <<BAN  
##################################################################################
#                Welcome in to the SOCENGINE UNIVERSE                            #
#                                                                                #
#  We want to help you empower your Security Monitoring                          #
#  with the tools that you need to setup a small Security                        #
#  Operations Center.                                                            #
#                                                                                #
#                                                                                #
#                                                                                #
#                                                                                #
#  This script will help you to install                                          #
#                                                                                #
#   - ELK as SIEM                                                                #
#   - TheHive Project as Incident MAnagement Tools                               #
#   - GRR as Incident Response tool                                              #
#   - Openvas (Greenbone Vulnerability Manager) as Vulnerbility Scanner          #
#   - SURICATA and ZEEK as IDS                                                   #
#                                                                                #
##################################################################################
BAN

install_date=$(date --rfc-3339=date)
logfile=/opt/socengine/logs/socengine_$creating_date.log
install_home=/opt/socengine/

#######Prepare the environment 

cat <<BAN  
####################################################
#              Environment setting up              #
####################################################
BAN

if (sudo ./preinstall.sh);	

then
	echo "**************************************Environment properly set up for the installation process*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************Environment properly set up for the installation process*****************" >> $logfile
else
	echo "**************************************Environment not properly set up for the installation process*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************Environment not properly set up for the installation process*****************" >> $logfile
	exit 0
fi

###############Installing ELK

if (sudo ELK/elk.sh);	

then
	echo "**************************************ELK SIEM successfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************ELK SIEM successfully installed*****************" >> $logfile
else
	echo "**************************************ELK SIEM has not been successfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************ELK SIEM has not been successfully installed*****************" >> $logfile
	exit 0
fi


###############Installing ZEEK

if (sudo ZEEK/zeek.sh);	

then
	echo "**************************************ZEEK IDS successfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************ZEEK IDS successfully installed*****************" >> $logfile
else
	echo "**************************************ZEEK IDS has not been successfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************ZEEK IDS has not been successfully installed*****************" >> $logfile
	exit 0
fi


###############Installing SURICATA

if (sudo SURICATA/suricata.sh);	

then
	echo "**************************************SURICATA IDS successfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************SURICATA IDS successfully installed*****************" >> $logfile
else
	echo "**************************************SURICATA IDS has not been successfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************SURICATA IDS has not been successfully installed*****************" >> $logfile
	exit 0
fi


###############Installing TheHive Project

if (sudo Thehive/thehive.sh);	

then
	echo "**************************************TheHive Project successfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************TheHive Project successfully installed*****************" >> $logfile
else
	echo "**************************************TheHive Project has not been successfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************TheHive Project has not been successfully installed*****************" >> $logfile
	exit 0
fi


###############Installing GRR

if (sudo GRR/grr_docker.sh);	

then
	echo "**************************************GRR Incident Response successfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************GRR Incident Response successfully installed*****************" >> $logfile
else
	echo "**************************************GRR Incident Response has not been successfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************GRR Incident Response has not been successfully installed*****************" >> $logfile
	exit 0
fi


###############Installing GRR

if (sudo GRR/grr_docker.sh);	

then
	echo "**************************************GRR Incident Response successfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************GRR Incident Response successfully installed*****************" >> $logfile
else
	echo "**************************************GRR Incident Response has not been successfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************GRR Incident Response has not been successfully installed*****************" >> $logfile
	exit 0
fi

###############Installing OPENVAS

if (sudo OPENVAS2_0/openvas.sh);	

then
	echo "**************************************OPENVAS successfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************OPENVAS successfully installed*****************" >> $logfile
else
	echo "**************************************OPENVAS has not been successfully installed*****************"
 	echo $(date --rfc-3339=seconds) >> $logfile
	echo "**************************************OPENVAS has not been successfully installed*****************" >> $logfile
	exit 0
fi

cat <<BAN  
####################################################
#     SOCENGINE TOOLS SUCCESFULLY DEPLOYED         #
####################################################
BAN
