#!/bin/bash
#
# uvdesk.sh
#
# This script is used to install OpenVas Server on a Debian based server 
#  
# 
# 
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
conf=./systemd.txt
mkdir /var/Openvas/
touch /var/Openvas/log.txt
redis_conf=./redis.conf

####################################################
#              Checking the source list            #
####################################################
  

  apt-get update
  apt-get upgrade -y


cat <<BAN  
####################################################
#            Installing Utils                      #
####################################################
BAN
sudo apt install -y software-properties-common ;\
sudo apt install -y cmake pkg-config libglib2.0-dev libgpgme-dev libgnutls28-dev uuid-dev libssh-gcrypt-dev \
libldap2-dev doxygen graphviz libradcli-dev libhiredis-dev libpcap-dev bison libksba-dev libsnmp-dev \
gcc-mingw-w64 heimdal-dev libpopt-dev xmltoman redis-server xsltproc libical-dev postgresql \
postgresql-contrib postgresql-server-dev-all gnutls-bin nmap rpm nsis curl wget fakeroot gnupg \
sshpass socat snmp smbclient libmicrohttpd-dev libxml2-dev python-polib gettext rsync xml-twig-tools \
python3-paramiko python3-lxml python3-defusedxml python3-pip python3-psutil virtualenv vim git libunistring-dev;\


sudo apt install -y texlive-latex-extra --no-install-recommends ;\
sudo apt install -y texlive-fonts-recommended ;\
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - ;\
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list ;\
sudo apt update ;\
sudo apt -y install yarn

#########################create user gvm
echo 'export PATH="$PATH:/opt/gvm/bin:/opt/gvm/sbin:/opt/gvm/.local/bin"' | sudo tee -a /etc/profile.d/gvm.sh ;\
sudo chmod 0755 /etc/profile.d/gvm.sh ;\
source /etc/profile.d/gvm.sh ;\
sudo bash -c 'cat << EOF > /etc/ld.so.conf.d/gvm.conf
# gmv libs location
/opt/gvm/lib
EOF'

####################"Create install dir"
sudo mkdir /opt/gvm ;\
sudo adduser gvm --disabled-password --home /opt/gvm/ --no-create-home --gecos '' ;\
sudo usermod -aG redis gvm  # This is for ospd-openvas can connect to redis.sock.. 
sudo chown gvm:gvm /opt/gvm/ ;\

sudo su - gvm

mkdir src ;\
cd src ;\
export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH

#####################Downloading the sources to build

git clone -b gvm-libs-11.0 --single-branch  https://github.com/greenbone/gvm-libs.git ;\
git clone -b openvas-7.0 --single-branch https://github.com/greenbone/openvas.git ;\
git clone -b gvmd-9.0 --single-branch https://github.com/greenbone/gvmd.git ;\
git clone -b master --single-branch https://github.com/greenbone/openvas-smb.git ;\
git clone -b gsa-9.0 --single-branch https://github.com/greenbone/gsa.git ;\
git clone -b ospd-openvas-1.0 --single-branch  https://github.com/greenbone/ospd-openvas.git ;\
git clone -b ospd-2.0 --single-branch https://github.com/greenbone/ospd.git

######################install gvm-libs

cd gvm-libs ;\
 export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH ;\
 mkdir build ;\
 cd build ;\
 cmake -DCMAKE_INSTALL_PREFIX=/opt/gvm .. ;\
 make ;\
 make doc ;\
 make install ;\
 cd /opt/gvm/src

########################config and build openvas-smb

cd openvas-smb ;\
 export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH ;\
 mkdir build ;\
 cd build/ ;\
 cmake -DCMAKE_INSTALL_PREFIX=/opt/gvm .. ;\
 make ;\
 make install ;\
 cd /opt/gvm/src


###################config and build scanner

cd openvas ;\
 export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH ;\
 mkdir build ;\
 cd build/ ;\
 cmake -DCMAKE_INSTALL_PREFIX=/opt/gvm .. ;\
 make ;\
 make doc ;\
 make install ;\
 cd /opt/gvm/src

################## Fix redis for default openvas install

su
export LC_ALL="C" ;\
/sbin/ldconfig ;\
cp /etc/redis/redis.conf /etc/redis/redis.orig ;\
cp /opt/gvm/src/openvas/config/redis-openvas.conf /etc/redis/ ;\
chown redis:redis /etc/redis/redis-openvas.conf ;\
echo "db_address = /run/redis-openvas/redis.sock" > /opt/gvm/etc/openvas/openvas.conf ;\
systemctl enable redis-server@openvas.service ;\
systemctl start redis-server@openvas.service

/sbin/sysctl -w net.core.somaxconn=1024
/sbin/sysctl vm.overcommit_memory=1


echo "net.core.somaxconn=1024"  >> /etc/sysctl.conf
echo "vm.overcommit_memory=1" ccccc /etc/sysctl.conf

cat << EOF > /etc/systemd/system/disable-thp.service
[Unit]
Description=Disable Transparent Huge Pages (THP)

[Service]
Type=simple
ExecStart=/bin/sh -c "echo 'never' > /sys/kernel/mm/transparent_hugepage/enabled && echo 'never' c /sys/kernel/mm/transparent_hugepage/defrag"

[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload ;\
systemctl start disable-thp ;\
systemctl enable disable-thp ;\
systemctl restart redis-server



######################As openvas will be launched from an ospd-openvas process with sudo, the next configuration is required in the sudoers file:

#visudo

#########################Edit the secure_path line to this.

echo "Defaults        secure_path=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/opt/gvm/sbin\"" >> /etc/sudoers

######"Add this line to allow the created gvm user to launch openvas with root permissions.

### Allow the user running ospd-openvas, to launch openvas with root permissions
echo "gvm ALL = NOPASSWD: /opt/gvm/sbin/openvas" >> /etc/sudoers
echo "gvm ALL = NOPASSWD: /opt/gvm/sbin/gsad" >> /etc/sudoers

su gvm

###############################update nvt

greenbone-nvt-sync

openvas -u

#####config and build manager


cd gvmd ;\
 export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH ;\
 sed -i 's/POSTGRES=0/POSTGRES=1/g' tools/gvm-portnames-update.in ;\
 mkdir build ;\
 cd build/ ;\
 cmake -DCMAKE_INSTALL_PREFIX=/opt/gvm .. ;\
 make ;\
 make doc ;\
 make install ;\
 cd /opt/gvm/src

################Configure PostgreSQL
su 

sudo -u postgres bash
export LC_ALL="C"
createuser -DRS gvm
createdb -O gvm gvmd

psql gvmd
create role dba with superuser noinherit;
grant dba to gvm;
create extension "uuid-ossp";
exit
exit

######fix certs
su gvm
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
cd /opt/gvm/src

###############configure and install gsa
cd gsa ;\
 export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH ;\
 mkdir build ;\
 cd build/ ;\
 cmake -DCMAKE_INSTALL_PREFIX=/opt/gvm .. ;\
 make ;\
 make doc ;\
 make install ;\
 touch /opt/gvm/var/log/gvm/gsad.log ;\
 cd /opt/gvm/src


###############OSPD-OPENVAS-----install the virtualenv

cd /opt/gvm/src ;\
export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH ;\
virtualenv --python python3.7  /opt/gvm/bin/ospd-scanner/ ;\
source /opt/gvm/bin/ospd-scanner/bin/activate

#########install ospd

mkdir /opt/gvm/var/run/ospd/ ;\
cd ospd ;\
pip3 install . ;\
cd /opt/gvm/src

#####################install ospd-openvas
cd ospd-openvas ;\
pip3 install . ;\
cd /opt/gvm/src


################creating startupscripts

su

cat << EOF > /etc/systemd/system/gvmd.service
[Unit]
Description=Open Vulnerability Assessment System Manager Daemon
Documentation=man:gvmd(8) https://www.greenbone.net
Wants=postgresql.service ospd-openvas.service
After=postgresql.service ospd-openvas.service

[Service]
Type=forking
User=gvm
Group=gvm
PIDFile=/opt/gvm/var/run/gvmd.pid
WorkingDirectory=/opt/gvm
ExecStart=/opt/gvm/sbin/gvmd --osp-vt-update=/opt/gvm/var/run/ospd.sock
ExecReload=/bin/kill -HUP $MAINPID
KillMode=mixed
Restart=on-failure
RestartSec=2min
KillMode=process
KillSignal=SIGINT
GuessMainPID=no
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF


cat << EOF > /etc/systemd/system/gsad.service
[Unit]
Description=Greenbone Security Assistant (gsad)
Documentation=man:gsad(8) https://www.greenbone.net
After=network.target
Wants=gvmd.service


[Service]
Type=forking
PIDFile=/opt/gvm/var/run/gsad.pid
WorkingDirectory=/opt/gvm
ExecStart=/opt/gvm/sbin/gsad --drop-privileges=gvm
Restart=on-failure
RestartSec=2min
KillMode=process
KillSignal=SIGINT
GuessMainPID=no
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF


cat << EOF > /etc/systemd/system/ospd-openvas.service 
[Unit]
Description=Job that runs the ospd-openvas daemon
Documentation=man:gvm
After=network.target redis-server@openvas.service
Wants=redis-server@openvas.service

[Service]
Environment=PATH=/opt/gvm/bin/ospd-scanner/bin:/opt/gvm/bin:/opt/gvm/sbin:/opt/gvm/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
Type=forking
User=gvm
Group=gvm
WorkingDirectory=/opt/gvm
PIDFile=/opt/gvm/var/run/ospd-openvas.pid
ExecStart=/opt/gvm/bin/ospd-scanner/bin/python /opt/gvm/bin/ospd-scanner/bin/ospd-openvas --pid-file /opt/gvm/var/run/ospd-openvas.pid --unix-socket=/opt/gvm/var/run/ospd.sock --log-file /opt/gvm/var/log/gvm/ospd-scanner.log --lock-file-dir /opt/gvm/var/run/ospd/
Restart=on-failure
RestartSec=2min
KillMode=process
KillSignal=SIGINT
GuessMainPID=no
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload ;\
systemctl enable gvmd ;\
systemctl enable gsad ;\
systemctl enable ospd-openvas ;\
systemctl start gvmd ;\
systemctl start gsad ;\
systemctl start ospd-openvas

systemctl status gvmd
systemctl status gsad
systemctl status ospd-openvas
##########################Modify Default Scanners###############""""
su gvm
gvmd --get-scanners
gvmd --modify-scanner=08b69003-5fc2-4037-a479-93b440211c73 --scanner-host=/opt/gvm/var/run/ospd.sock

cat <<BAN  
#################################################### 
        Installation Successfully done
    Login to the Web interface by https://your_ip
    Login: admin
    Password: admin  

####################################################
BAN

