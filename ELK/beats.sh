#!/bin/bash
#
# beats.sh
#
# This script is used to install Elastic data Shippers on a Deb Unix system 
# Metricbeat, Auditbeat, Filebeat, Heartbeat
# 
#
# Authors: Silas VIGAN
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list


sudo apt-get update && sudo apt-get install filebeat metricbeat auditbeat heartbeat
sudo systemctl enable filebeat
sudo systemctl enable metricbeat
sudo systemctl enable auditbeat
sudo systemctl enable heartbeat


filebeat modules enable system apache auditd elasticsearch gcp iptables mysql postgresql suricata zeek



AAEAAWVsYXN0aWMvZmxlZXQtc2VydmVyL3Rva2VuLTE2MzAyNDIwOTA4ODA6NFNhTXd5cThSUENGLWducV9MOE5odw


kibana
PASSWORD kibana = 8yxY65CFxreYms9PgJxF
