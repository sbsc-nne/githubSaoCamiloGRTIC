#!/bin/bash
# Data Criação: 20-09-2023
# @Marcelo Grando
# Script config_backup_monitor Balsas

echo '##### Iniciando configuração #####'

DIR_OLD="/etc/zabbix/script-python"
DIR="/etc/zabbix/script"

if [ -d "$DIR_OLD" ]; then
  # O diretório existe, então vamos excluí-lo
  rm -rf "$DIR_OLD"
fi

if [ ! -d "$DIR" ]; then
  mkdir -p $DIR && cd $DIR
fi

chmod 777 -R $DIR

echo '##### Download do arquivo criar_diretorios_backups.sh #####'

wget -O /tmp/criar_diretorios_backups.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/criar_diretorios_backups.sh

sh /tmp/criar_diretorios_backups.sh

echo '##### Download do arquivos script #####'

rm -rf /etc/zabbix/script/*

wget -O /etc/zabbix/script/last_file_date.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/script/last_file_date.sh
wget -O /etc/zabbix/script/last_file_name.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/script/last_file_name.sh
wget -O /etc/zabbix/script/last_file_size.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/script/last_file_size.sh
wget -O /etc/zabbix/script/mount_storage.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/unidades/BAL-mount_storage.sh


echo '##### Download do arquivos zabbix_agentd.d userparameter #####'

$fileUserParameter="/etc/zabbix/zabbix_agentd.d/userparameter_info_last_file_bkp.conf"
if [ -e "$fileUserParameter" ]; then
    rm "$fileUserParameter"
fi

wget -O $fileUserParameter https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/unidades/BAL-userparameter_info_last_file_bkp.conf
wget -O /etc/zabbix/zabbix_agentd.d/userparameter_size_used_storage.conf https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/zabbix_agentd.d/userparameter_size_used_storage.conf

sleep 3s
sh /etc/zabbix/script/mount_storage.sh

echo '##### Finalizado #####'
