#!/bin/bash
# Data Criação: 27-11-2023
# @Marcelo Grando
# Script instar e configurar a validação de integridade do Backup do SystemaH

echo '##### Iniciando configuração #####'

DIR1="/home/check_db_pgsql"
DIR2="/home/check_db_pgsql/logs_backup"

if [ ! -d "$DIR1" ]; then
  mkdir -p $DIR1 && cd $DIR1
  mkdir -p $DIR2
fi

echo '##### Download do arquivo... #####'

wget -O /home/check_db_pgsql/verificar_integridade_postgresql.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-integridade-postgresql/verificar_integridade_postgresql.sh
wget -O /home/check_db_pgsql/ler_log_integridade_postgresql.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-integridade-postgresql/ler_log_integridade_postgresql.sh
wget -O /etc/zabbix/zabbix_agentd.d/userparameter_integridade_postgresql.conf https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-integridade-postgresql/userparameter_integridade_postgresql.conf

chmod +x /home/check_db_pgsql/verificar_integridade_postgresql.sh
chmod +x /home/check_db_pgsql/ler_log_integridade_postgresql.sh

echo "# Executar verificação integridade backup SystemaH" >> /etc/crontab
echo "02 */6 * * *    root    /home/check_db_pgsql/verificar_integridade_postgresql.sh systema" >> /etc/crontab

/etc/init.d/cron reload 
