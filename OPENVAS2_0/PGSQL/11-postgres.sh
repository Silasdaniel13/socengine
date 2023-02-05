#!/bin/bash
#
# uvdesk.sh
#
# This script is used to configure Postgres SQL 
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
#           Postgres SQL Configuration             #
####################################################
BAN

###Installing the PostgreSQL server

sudo apt install -y postgresql

###Starting the PostgreSQL database server

sudo systemctl start postgresql@13-main

###Setting up PostgreSQL user and database

sudo -u postgres bash
createuser -DRS gvm
createdb -O gvm gvmd
exit

###Setting up database permissions and extensions

sudo -u postgres bash
psql gvmd
create role dba with superuser noinherit;
grant dba to gvm;

exit

exit

####