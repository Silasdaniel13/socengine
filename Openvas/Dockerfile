# syntax=docker/dockerfile:1
FROM debian:latest

MAINTAINER Silas VIGAN <silasdaniel13@gmail.com>
#COPY . /app
#Update the sources and creating gvm user and installation directory
RUN apt-get update 
RUN useradd -r -d /opt/gvm -c "GVM User" -s /bin/bash gvm 
RUN mkdir /opt/gvm
RUN chown gvm: /opt/gvm


#Installing The librairies needed to RUN Openvas

RUN   apt install -y gcc g++ make bison flex libksba-dev curl redis libpcap-dev \
cmake git pkg-config libglib2.0-dev libgpgme-dev nmap libgnutls28-dev uuid-dev \
libssh-gcrypt-dev libldap2-dev gnutls-bin libmicrohttpd-dev libhiredis-dev \
zlib1g-dev libxml2-dev libradcli-dev clang-format libldap2-dev doxygen \
gcc-mingw-w64 xml-twig-tools libical-dev perl-base heimdal-dev libpopt-dev  libunistring-dev graphviz \
libsnmp-dev python3-setuptools python3-paramiko python3-lxml python3-defusedxml python3-dev gettext python3-polib xmltoman \
python3-pip texlive-fonts-recommended texlive-latex-extra --no-install-recommends xsltproc sudo vim rsync       

#Installin Yarn JavaScript package manager on Debian 

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update
RUN apt install yarn -y

#Install PostgreSQL on Debian 10 GVM 20.08 uses PostgreSQL 
#as the backend database. Therefore, run the command below to install PostgreSQL on Debian 10

#RUN apt-get install -y postgresql postgresql-contrib postgresql-server-dev-all


#Create PostgreSQL User and Database

#RUN sudo -Hiu postgres
#UN createuser gvm
#RUN createdb -O gvm gvmd
#RUN psql gvmd \
#    create role dba with superuser noinherit; \
#    grant dba to gvm; \
#    create extension "uuid-ossp"; \
#    create extension "pgcrypto"; \
#    \q  \
#    exit

#CMD systemctl restart postgresql
#CMD systemctl enable postgresql

#ADD ./suricata.yaml /etc/suricata/suricata.yaml
#ADD ./suricata.rules /etc/suricata/rules/suracata.rules


#Update commands after editing some files 
#RUN suricata-update
#RUN suricata-update update-sources
#RUN suricata-update enable-source oisf/trafficid
#RUN suricata-update enable-source etnetera/aggressive
#RUN suricata-update enable-source sslbl/ssl-fp-blacklist
#RUN suricata-update enable-source et/open
#RUN suricata-update enable-source tgreen/hunting
#RUN suricata-update enable-source sslbl/ja3-fingerprints
#RUN suricata-update enable-source ptresearch/attackdetection
#RUN suricata-update




#CMD to be executed
#CMD systemctl enable suricata
#CMD systemctl start suricata
#CMD systemctl start suricata