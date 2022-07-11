#!/bin/bash
#
# uvdesk.sh
#
# This script is used to build gvmd 
#  
# 
# 
# 
#
# Authors:
#  Silas VIGAN <sisedaro05@yahoo.fr>
#
# 

export LC_ALL="C"

createuser -DRS gvm

createdb -O gvm gvmd

psql -c"create role dba with superuser noinherit" gvmd
psql -c"grant dba to gvm" gvmd
psql -c"create extension \"uuid-ossp\"" gvmd
