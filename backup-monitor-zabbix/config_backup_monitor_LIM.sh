#!/bin/bash
# Data Criação: 20-09-2023
# @Marcelo Grando
# Script config_backup_monitor Limoeiro do Norte

echo '##### Iniciando configuração #####'

if [! -d "/etc/zabbix/script-python"]; then
    mkdir /etc/zabbix/script-python
    chmod 777 -R /etc/zabbix/script-python
fi

cd /etc/zabbix/script-python

echo '##### Download do arquivo criar_diretorios_backups.sh #####'

wget https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/criar_diretorios_backups.sh
sleep 3s

sh criar_diretorios_backups.sh

echo '##### Download do arquivos script-python #####'

wget https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/script-python/info_last_file_bkp.py
wget https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/script-python/last_file_date.py
wget https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/script-python/last_file_name.py
wget https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/script-python/last_file_size.py
wget -O mount_storage.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/unidades/LIM-mount_storage.sh

cd /etc/zabbix/zabbix_agentd.d

echo '##### Download do arquivos zabbix_agentd.d userparameter #####'

wget -O userparameter_info_last_file_bkp.conf https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/unidades/LIM-userparameter_info_last_file_bkp.conf
wget https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/zabbix_agentd.d/userparameter_size_used_storage.conf

echo '##### Finalizado #####'