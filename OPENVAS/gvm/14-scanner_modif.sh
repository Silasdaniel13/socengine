#!/bin/bash
#
# uvdesk.sh
#
# This script is used to modify the scanner 
#  
# 
# 
# 
#
# Authors:
#  Silas VIGAN <sisedaro05@yahoo.fr>
#
# 
gvmd --get-scanners
gvmd --modify-scanner=08b69003-5fc2-4037-a479-93b440211c73 --scanner-host=/opt/gvm/var/run/ospd.sock

cat <<BAN  
#################################################### 
        Installation Successfully done
    Login to the Web interface by https://your_ip
    Login: admin
    Password: admin  

####################################################