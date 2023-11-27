#!/bin/bash
# Data Criação: 27-11-2023
# @Marcelo Grando
# dir = /tmp/install_verifica_integridade.sh
# Script instar e configurar a validação de integridade do Backup do SystemaH

echo '##### Iniciando configuração #####'

# Diretorios onde devem estar os scripts
DIR1="/home/check_db_pgsql"
# Diretorios onde serão salvos os LOGs
DIR2="/home/check_db_pgsql/logs_backup"

# Criar os diretórios caso não existam.
if [ ! -d "$DIR1" ]; then
  mkdir -p $DIR1
  mkdir -p $DIR2
fi

echo '##### Download do arquivo... #####'
# Download dos scripts para a pasta /home/check_db_pgsql/
wget -O /home/check_db_pgsql/verificar_integridade_postgresql.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-integridade-postgresql/verificar_integridade_postgresql.sh
wget -O /home/check_db_pgsql/ler_log_integridade_postgresql.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-integridade-postgresql/ler_log_integridade_postgresql.sh

# Download do arquivo de userparamenter do zabbix para a pasta /etc/zabbix/zabbix_agentd.d/
wget -O /etc/zabbix/zabbix_agentd.d/userparameter_integridade_postgresql.conf https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-integridade-postgresql/userparameter_integridade_postgresql.conf

# Dar permissão de execução aos scripts
chmod +x /home/check_db_pgsql/verificar_integridade_postgresql.sh
chmod +x /home/check_db_pgsql/ler_log_integridade_postgresql.sh

echo '##### Fim Download do arquivo... #####'

# Inserir a linha no cron para executar o script a cada 6 horas iniciando as 02:00
echo "# Executar verificação integridade backup SystemaH" >> /etc/crontab
echo "02 */6 * * *    root    /home/check_db_pgsql/verificar_integridade_postgresql.sh systema" >> /etc/crontab

# Reiniciar o serviço do cron
echo '##### Reiniciar cron... #####'
/etc/init.d/cron reload 

# Reiniciar o serviço do Zabbix Agent
echo '##### Reiniciar zabbix-agent... #####'
service zabbix-agent restart

# Executar o script para fazer a primeiras verificação da integridade.
/home/check_db_pgsql/verificar_integridade_postgresql.sh systema
