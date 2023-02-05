#!/bin/bash
#
# uvdesk.sh
#
# This script is used to Download and install Docker engne on Debian 11
#  
# 
# 
# 
#
# Authors:
#  Silas VIGAN <sisedaro05@yahoo.fr>
#
# 

cat <<BAN  
####################################################
#          Download and install Docker            #
####################################################
BAN

##Set up the repository
#
#    Update the apt package index and install packages to allow apt to use a repository over HTTPS:
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

#Add Docker’s official GPG key:

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

### Use the following command to set up the repository:

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#Update the apt package index:
sudo apt-get update


#Install Docker Engine, containerd, and Docker Compose.

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

#Run Docker GRR SERVER
ocker run   --name grr-server   -e EXTERNAL_HOSTNAME=socengine   -e ADMIN_PASSWORD=admin   -p 0.0.0.0:8000:8000 -p 0.0.0.0:8080:8080   grrdocker/grr:v3.4.6.0 &
