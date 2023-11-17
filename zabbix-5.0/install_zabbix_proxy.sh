#!/bin/bash
# @Marcelo Grando
# Date: 10-04-2022
# Upgrade do SO ultima build

echo '##### Iniciando atualização Ubuntu #####'
sleep 2s
sudo apt-get update
sudo apt-get -y upgrade
sudo apt list --upgradable
sudo apt clean
sudo apt update
sudo apt -y upgrade
echo '##### Setar a data e hora corretamente para America/Fortaleza #####'
sleep 2s
sudo timedatectl set-timezone America/Fortaleza
sudo timedatectl status
sleep 3s
echo '###### Instalar alguns pacotes básicos #####'
sleep 2s
sudo apt-get install  -y telnet net-tools vim nano wget curl tcpdump
echo '##### Baixar o repositório do zabbix 5.0 #####'
sleep 2s
cd /tmp
wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1%2Bfocal_all.deb
# Aplicar o arquivo de repositório no gerenciador de pacotes
sudo dpkg -i zabbix-release_5.0-1+focal_all.deb
# Atualizar os repositórios
sudo apt update
echo '##### Instalar os pacotes do zabbix proxy, agente e banco de dados #####'
sleep 2s
apt-get install -y zabbix-proxy-sqlite3 zabbix-agent zabbix-get zabbix-sender
# Criar diretório para o DB do Zabbix e dar as permissões
mkdir /var/lib/zabbix
chown zabbix. -R /var/lib/zabbix/
echo '##### Setar os paramentros no arquivo de configuração /etc/zabbix/zabbix_proxy.conf #####'
sleep 2s
sudo sed -i '30 s/Server=127.0.0.1/Server=10.10.50.47/' /etc/zabbix/zabbix_proxy.conf
sudo sed -i 's/Hostname=Zabbix proxy/# Hostname=Zabbix proxy/' /etc/zabbix/zabbix_proxy.conf
sudo sed -i 's/# EnableRemoteCommands=0/EnableRemoteCommands=1/' /etc/zabbix/zabbix_proxy.conf
sudo sed -i 's/DBName=zabbix_proxy/DBName=\/var\/lib\/zabbix\/zabbix.db/' /etc/zabbix/zabbix_proxy.conf
sudo sed -i 's/# ProxyOfflineBuffer=1/ProxyOfflineBuffer=24/' /etc/zabbix/zabbix_proxy.conf
sudo sed -i 's/# ConfigFrequency=3600/ConfigFrequency=300/' /etc/zabbix/zabbix_proxy.conf
echo '##### Habilitar inicialização automática, iniciar o serviço e abrir o log #####'
sleep 2s
systemctl enable --now zabbix-proxy
echo '##### Instalação finalizada #####'
sleep 3s
tail -f /var/log/zabbix/zabbix_proxy.log