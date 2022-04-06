#!/bin/bash
#
# uvdesk.sh
#
# This script is used to install UVDESK Server on a Debian based server 
# To do so we will need to set up 
# Apache2 Server
# Mariadb SQL Server
# Php7.4
#
# Authors:
#  Silas VIGAN <sisedaro05k@yahoo.fr>
#
# 

#VERSION=0.0.1
#HOST=$1
#PORT=${2:-443}
sourcelist=./sources.list
conf=./uvdesk.conf
mkdir /var/UVDESK/
touch /var/UVDESK/log.txt

####################################################
#              Checking the source list            #
####################################################
  
if test -f "$sourcelist";
then 
#  cat ./sources.list >> /etc/apt/sources.list
  apt-get update
  apt-get upgrade -y

else
  echo "[ERROR]: Source file missing in the script directory" 
  exit 0 
fi

####################################################
#            Installing Apache2 Server             #
####################################################


cat <<BAN  
#################################################### 
#          Installing Apache Server                #
####################################################
BAN

if apt-get install -y apache2;
then
  systemctl stop apache2.service
  systemctl start apache2.service
  systemctl enable apache2.service

  echo "***********************************Apache Server Installed successfully******************************"
  echo $(date --rfc-3339=seconds) > /var/UVDESK/log.txt
  echo "   ****************Apache Server Installed successfully*********************" >> /var/UVDESK/log.txt

else
  echo "[ERROR]:  Installing Apache 2 server FAILED " 
  echo $(date --rfc-3339=seconds) >> /var/UVDESK/log.txt
  echo "  [ERROR]: Installing Apache 2 server FAILED " >> /var/UVDESK/log.txt  
fi  
####################################################
#               Installing Maria DB                #
####################################################

cat <<BAN  
#################################################### 
#          Installing Maria DB                     #
####################################################
BAN

if apt install -y mariadb-server mariadb-client;
then
  systemctl stop mariadb.service
  systemctl start mariadb.service
  systemctl enable mariadb.service
  mysql_secure_installation
  echo "***********************************Maria DB Server Installed successfully******************************"
  echo $(date --rfc-3339=seconds) >> /var/UVDESK/log.txt
  echo "   ****************Maria DB Server Installed successfully*********************" >> /var/UVDESK/log.txt
  systemctl restart mariadb.service
  echo "***********************************Creating UVDESK DATABASE******************************"
  echo " Please type in below the root password of MySQL"
  read -s -p "Password: " rootSqlPw
  comparer=1
  echo " Please type in below the password for the uvdesk user"
  read -s -p "Password: " uvdeskPw
  echo " Please confirm the password for the uvdesk user"
  read -s -p "Password: " PwConfirm
  if [[ $uvdeskPw == $PwConfirm ]]
  then 
    comparer=0
  else 
    until [[ $comparer == 0 ]]
    do
      echo "The password and the confirmation are not the same"
      echo " Please type again the password for the uvdesk user"
      read -s -p "Password: " uvdeskPw
      echo " Please again the password for the uvdesk user"
      read -s -p "Password: " PwConfirm
      if [[ $uvdeskPw -eq $PwConfirm ]]
      then 
        comparer=0
      fi
    done
  fi  
   mysql -u root -p$rootSqlPw -e "CREATE DATABASE uvdesk;" 
   mysql -u root -p$rootSqlPw -e "CREATE USER 'uvdeskadmin'@'localhost' IDENTIFIED BY '$uvdeskPw';"
   mysql -u root -p$rootSqlPw -e "GRANT ALL ON uvdesk.* TO 'uvdeskadmin'@'localhost' WITH GRANT OPTION;"
   mysql -u root -p$rootSqlPw -e "FLUSH PRIVILEGES;"


 
  echo "***********************************UVDESK Database and user successfully created******************************"
  echo $(date --rfc-3339=seconds) >> /var/UVDESK/log.txt
  echo "   ****************UVDESK Database and user successfully created*********************" >> /var/UVDESK/log.txt
else
  echo "[ERROR]: Installing Maria DB server FAILED" 
  echo $(date --rfc-3339=seconds) >> /var/UVDESK/log.txt
  echo "  [ERROR]: Installing Maria DB server FAILED " >> /var/UVDESK/log.txt  
fi



####################################################
#               Installing PHP 7.4                 #
####################################################

cat <<BAN  
#################################################### 
#          Installing PHP 7.4                      #
####################################################
BAN

apt -y install lsb-release apt-transport-https ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg #Adding the Repo for PHP
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list

apt update                        # Update the source list

apt install -y php7.4 
apt install -y libapache2-mod-php7.4 php7.4-common php7.4-gmp php7.4-curl php7.4-intl php7.4-mbstring php7.4-xmlrpc php7.4-mysql php7.4-gd php7.4-xml php7.4-imap php7.4-mailparse php7.4-cli php7.4-zip

systemctl restart apache2.service
echo "***********************************PHP 7.4 successfully Installed******************************"
echo $(date --rfc-3339=seconds) >> /var/UVDESK/log.txt
echo "   ****************PHP 7.4 successfully Installed*********************" >> /var/UVDESK/log.txt


####################################################
#               Installing UVDESK                  #
####################################################

cat <<BAN  
#################################################### 
#          Installing UVDESK                      #
####################################################
BAN


apt install -y curl git
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
mkdir /var/www/uvdesk
chown $USER:$USER /var/www/uvdesk
composer clear-cache
composer create-project uvdesk/community-skeleton helpdesk-project
chown -R www-data:www-data /var/www/uvdesk/
chmod -R 755 /var/www/uvdesk/
echo " 127.0.0.1       helpdesk.local" >> /etc/hosts

if test -f "$conf";
then 
  cp $conf /etc/apache2/sites-available/
  sudo a2ensite uvdesk.conf
  sudo a2enmod rewrite
  systemctl restart apache2.service
     
else
  echo "[ERROR]: Config file (uvdesk.conf) is missing in the script directory" 
  exit 0 
fi

cat <<FIN  
#################################################### 
    UVDESK  HAVE BEEN SUCCESSFULLY INSTALLED

    >> go to the link: http://helpdesk.local to 
      for the final configuration using the details 
      below

    >> Server == localhost
    >> Port == 3306
    >>Username == uvdeskadmin
    >> Password == Pasword_of_uvdesk_user
    >> Database == uvdesk      

####################################################
FIN


exit 0




