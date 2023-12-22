#!/bin/bash
# Data Criação: 20-09-2023
# Data Atualização: 04-12-2023
# @Marcelo Grando
# Script config_backup_monitor Pedro II

clear
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

# Baixar o arquivo para criar os diretorios que serão usados no mapeamento
wget -O /tmp/criar_diretorios_backups.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/criar_diretorios_backups.sh

# Executar o arquivo para criar os diretorios que serão usados no mapeamento
sh /tmp/criar_diretorios_backups.sh

echo '##### Download do arquivos script #####'

# Limpa a pasta de scripts antes de fazer o download dos arquivos novos
rm -rf /etc/zabbix/script/*

# Baixar os arquivos de configuração
wget -O /etc/zabbix/script/last_file_date.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/script/last_file_date.sh
wget -O /etc/zabbix/script/last_file_name.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/script/last_file_name.sh
wget -O /etc/zabbix/script/last_file_size.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/script/last_file_size.sh
wget -O /etc/zabbix/script/validar_backup.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/script/validar_backup.sh
wget -O /etc/zabbix/script/mount_storage.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/unidades/PII-mount_storage.sh

echo '##### Download do arquivos zabbix_agentd.d userparameter #####'

# Remover o arquivo userparameter_info_last_file_bkp.conf antes de baixar a nova versão
$infoLastFile="/etc/zabbix/zabbix_agentd.d/userparameter_info_last_file_bkp.conf"
if [ -e "$infoLastFile" ]; then
  rm "$infoLastFile"
  echo '##### Arquivo userparameter_info_last_file_bkp.conf excluido #####'
fi
$sizeUsedStorage="/etc/zabbix/zabbix_agentd.d/userparameter_size_used_storage.conf"
if [ -e "$sizeUsedStorage" ]; then
  rm "$sizeUsedStorage"
  echo '##### Arquivo userparameter_size_used_storage.conf excluido #####'
fi
# Baixar os arquivos userparameter_info_last_file_bkp.conf
wget -O /etc/zabbix/zabbix_agentd.d/userparameter_info_last_file_bkp.conf https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/unidades/PII-userparameter_info_last_file_bkp.conf
wget -O /etc/zabbix/zabbix_agentd.d/userparameter_size_used_storage.conf https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/zabbix_agentd.d/userparameter_size_used_storage.conf

sleep 2s

# Exetuda o arquivo para montar as pastas da Storage
if ! mount | grep -q "FortesAC";
then
  sh /etc/zabbix/script/mount_storage.sh
fi
chmod 777 -R $DIR

# Inserir a linha no cron para executar o script a cada 6 horas iniciando as 02:00
echo "# Montar os compartilhamentos com Storage" >> /etc/crontab
echo "@reboot         root    sh /etc/zabbix/script/mount_storage.sh" >> /etc/crontab

# Reiniciar o serviço do cron
echo '##### Reiniciar cron... #####'
/etc/init.d/cron reload 

echo '##### Finalizado #####'
echo '##### Configurando Crontab #####'
echo '##### Deverá ser configurado manualmente o crontab: vi /etc/crontab #####'
echo '##### Linha comando para add: @reboot         root    sh /etc/zabbix/script/mount_storage.sh'
