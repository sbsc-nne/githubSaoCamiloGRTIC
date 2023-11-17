#!/bin/bash

# Instalar o zabbix agent 2 versão 5.0 em servidores Ubuntu
echo "Informe qual é o IP do Zabbix Proxy:"
read IP_SERVIDOR;
ZABBIX_CONF=/etc/zabbix/zabbix_agentd.conf

#LIMPA A CONSOLE
clear

# acessar a posta temp
cd /tmp/

#Ubuntu 20.04 (Focal)
sudo wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1%2Bfocal_all.deb
sudo sudo dpkg -i zabbix-release_5.0-1+focal_all.deb

# Atualizar o respositório
sudo apt-get update -y

# Instalar o agent
sudo apt-get install zabbix-agent -y

#  Configurar o Agente Zabbix
sed -i -e"s/^Server=127.0.0.1.*$/Server=$IP_SERVIDOR/" $ZABBIX_CONF
sed -i -e"s/^ServerActive=127.0.0.1.*$/ServerActive=$IP_SERVIDOR/" $ZABBIX_CONF
sed -i -e"s/^Hostname=Zabbix.*$/# Hostname=Zabbix server/" $ZABBIX_CONF
sed -i -e"s/^# HostMetadata=.*$/HostMetadata=server-linux/" $ZABBIX_CONF
sed -i -e"s/^# HostMetadataItem=.*$/HostMetadataItem=system.hostname/" $ZABBIX_CONF

# Ubuntu 20.04 (Focal)
sudo systemctl enable zabbix-agent
sudo systemctl restart zabbix-agent

sudo systemctl status zabbix-agent