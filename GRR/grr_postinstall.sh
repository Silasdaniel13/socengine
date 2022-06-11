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
install_home=/opt/socengine/GRR
install_date=$(date --rfc-3339=date)
logfile=/opt/socengine/logs/grr_$creating_date.log
mkdir $install_home
touch $logfile

libssl_version=1.0.0
grr_source="https://storage.googleapis.com/releases.grr-response.com/grr-server_3.2.1-1_amd64.deb"
grr_deb_file=grr-server_3.2.1-1_amd64.deb

####################################################
#              editing /etc/grr file               #
####################################################
  
  
  
####################################################
#              Restarting GRR Server               #
####################################################
systemctl restart grr-server




#################################################################
#      Configuring Nginx to Run GRR UI behind HTTPS Proxy       #
#################################################################

apt install -y nginx


openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/grr-server.key -out /etc/nginx/grr-server.crt


chmod 644 /etc/nginx/grr-server.crt
chmod 400 /etc/nginx/grr-server.key







**************************************************************************
server {

    listen 443;
    server_name grr-server.local;

    ssl_certificate           /etc/nginx/grr-server.crt;
    ssl_certificate_key       /etc/nginx/grr-server.key;

    ssl on;
    ssl_session_cache  builtin:1000  shared:SSL:10m;
    ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4;
    ssl_prefer_server_ciphers on;

    access_log            /var/log/nginx/grr.access.log;

    location / {

    proxy_set_header        Host $host;
    proxy_set_header        X-Real-IP $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header        X-Forwarded-Proto $scheme;

     proxy_pass          http://localhost:8000;
     proxy_read_timeout  180;

     proxy_redirect      http://l:8000 https://grr-server.local;
    }
}
***************************************************************



####################################################
#              editing /etc/grr file               #
####################################################
  
  
  
   mysql -u root -p$rootSqlPw -e "CREATE DATABASE grr;" 
   mysql -u root -p$rootSqlPw -e "grant all privileges on grr.* to grr@$host identified by '$password';;"
   mysql -u root -p$rootSqlPw -e "FLUSH PRIVILEGES;"


