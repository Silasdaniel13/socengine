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
#sourcelist=./sources.list
conf=./uvdesk.conf
install_date=$(date --rfc-3339=date)
logfile=/opt/socenngine/logs/uvdesk_$creating_date.log
install_home=/opt/socenngine/UVDESK/
touch $logfile
mkdir $install_home
php_version=php8.0

####################################################
#              Checking the source list            #
####################################################
  
#if test -f "$sourcelist";
#then 
#  cat ./sources.list >> /etc/apt/sources.list
#  apt-get update
#  apt-get upgrade -y

#else
#  echo "[ERROR]: Source file missing in the script directory" 
#  exit 0 
#fi

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
  systemctl enable apache2.service
  systemctl start apache2.service
  

  echo "***********************************Apache Server Installed successfully******************************"
  echo $(date --rfc-3339=seconds) > $logfile
  echo "   ****************Apache Server Installed successfully*********************" >> $logfile

else
  echo "[ERROR]:  Installing Apache 2 server FAILED " 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "  [ERROR]: Installing Apache 2 server FAILED " >> $logfile  
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
  systemctl enable mariadb.service
  systemctl start mariadb.service
  
  mysql_secure_installation
  echo "***********************************Maria DB Server Installed successfully******************************"
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "   ****************Maria DB Server Installed successfully*********************" >> $logfile
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
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "   ****************UVDESK Database and user successfully created*********************" >> $logfile
else
  echo "[ERROR]: Installing Maria DB server FAILED" 
  echo $(date --rfc-3339=seconds) >> $logfile
  echo "  [ERROR]: Installing Maria DB server FAILED " >> $logfile 
fi



####################################################
#               Installing PHP                     #
####################################################

cat <<BAN  
#################################################### 
#          Installing PHP                          #
####################################################
BAN

apt -y install lsb-release apt-transport-https ca-certificates
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list  ####Add the PHP packages APT repository to your Debian server
wget  -P $install_home /opt/socengine/-qO - https://packages.sury.org/php/apt.gpg | sudo apt-key add - ####   Import repository key

apt update                        # Update the source list

apt install -y $php_version
apt install -y libapache2-mod-$php_version $php_version-common $php_version-gmp $php_version-curl $php_version-intl $php_version-mbstring $php_version-xmlrpc $php_version-mysql $php_version-gd $php_version-xml $php_version-imap $php_version-mailparse $php_version-cli $php_version-zip

systemctl restart apache2.service
echo "***********************************PHP successfully Installed******************************"
echo $(date --rfc-3339=seconds) >> $logfile
echo "   ****************PHP successfully Installed*********************" >> $logfile


####################################################
#               Installing UVDESK                  #
####################################################

cat <<BAN  
#################################################### 
#          Installing UVDESK                      #
####################################################
BAN


apt install -y curl git
wget  https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
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
   echo $(date --rfc-3339=seconds) >> $logfile
  echo "[ERROR]: Config file (uvdesk.conf) is missing in the script directory"  >> $logfile 
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




