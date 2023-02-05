#!/bin/bash
#
# grr.sh
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
#conf=./uvdesk.conf




####################################################
#            Installing GRR Server                 #
####################################################


cat <<BAN  
#################################################### 
#          Installing GRR SERVER                   #
####################################################

A Docker Containe of GRR SERVER will Downloaded and installed
************************************************************************** 
BAN


#######Copy over the initial configs for the server installation from GRR’s image to the host’s filesystem:


mkdir ~/grr-docker

docker create --name grr-server grrdocker/grr:v3.4.6.0

docker cp grr-server:/usr/share/grr-server/install_data/etc ~/grr-docker

docker rm grr-server

######Start a new container 

docker run \
  --name grr-server \
  -e EXTERNAL_HOSTNAME=socengine \
  -e ADMIN_PASSWORD=demo \
  -p 0.0.0.0:8000:8000 -p 0.0.0.0:8080:8080 \
  -v /home/admin/grr-docker/etc:/usr/share/grr-server/install_data/etc \
  -v /var/log/grr:/usr/share/grr-server/lib/python2.7/site-packages/grr_response_core/var/log \
   grrdocker/grr:v3.4.6.0 \ 