#!/bin/bash
#
# uvdesk.sh
#
# This script is used to download OpenVas Server Install Source Files on a Debian based server 
#  
# 
# 
# 
#
# Authors:
#  Silas VIGAN <sisedaro05@yahoo.fr>
#
# 
cd /opt/gvm/src 
gvm-manage-certs -a

##########Create admin user
gvmd --create-user=admin --password=admin

##########update feeds

greenbone-certdata-sync

########update IANA Service names
mkdir iana_service_ports ;\
cd iana_service_ports ;\
wget https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xml ;\
gvm-portnames-update service-names-port-numbers.xml