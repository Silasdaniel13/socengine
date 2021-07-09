# syntax=docker/dockerfile:1
FROM debian:latest

MAINTAINER Silas VIGAN <silasdaniel13@gmail.com>
#COPY . /app
#RUN add-apt-repository ppa:oisf/suricata-stable
RUN apt-get update 
RUN apt-get install -y apt-utils 
RUN apt-get install -y suricata
RUN apt install -y python3-pip
RUN pip3 install pyyaml
RUN pip3 install https://github.com/OISF/suricata-update/archive/master.zip
RUN pip3 install --pre --upgrade suricata-update

#Files updating
ADD ./suricata /etc/default/suricata
ADD ./suricata.yaml /etc/suricata/suricata.yaml
ADD ./suricata.rules /etc/suricata/rules/suracata.rules


#Update commands after editing some files 
RUN suricata-update
RUN suricata-update update-sources
RUN suricata-update enable-source oisf/trafficid
RUN suricata-update enable-source etnetera/aggressive
RUN suricata-update enable-source sslbl/ssl-fp-blacklist
RUN suricata-update enable-source et/open
RUN suricata-update enable-source tgreen/hunting
RUN suricata-update enable-source sslbl/ja3-fingerprints
RUN suricata-update enable-source ptresearch/attackdetection
RUN suricata-update




#CMD to be executed
CMD systemctl enable suricata
CMD systemctl start suricata
CMD systemctl start suricata