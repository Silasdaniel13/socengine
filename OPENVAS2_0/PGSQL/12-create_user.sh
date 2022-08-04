#!/bin/bash
#
# uvdesk.sh
#
# This script is used to create admin user
#  
# 
# 
#
#  Authors:
#  Silas VIGAN <sisedaro05@yahoo.fr>
#
# 
#
cat <<BAN  
####################################################
#              Admin user Creating                 #
####################################################
BAN

###Creating an administrator user with generated password

gvmd --create-user=admin

###Creating an administrator user with provided password

gvmd --create-user=admin --password=<admin>