#!/bin/bash
# Data Criação: 27-11-2023
# @Marcelo Grando
# dir = /tmp/install_verifica_integridade.sh
# Script instalar e configurar a validação de integridade do Backup do SystemaH

echo "## ATENÇÃO ## O PostgreSQL precisa esta instalado nesse servidor"
read -p "Deseja instalar? Informar 1 = SIM | 2 = NÃO : " flag_continuar;
if [ $flag_continuar = '1' ]
then
    echo '##### Baixando arquivo para instalar PostgreSQL 9.4.26 #####'
    wget -O /tmp/install_postgresql_9_4_26.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-integridade-postgresql/install_postgresql_9_4_26.sh
    chmod +x /tmp/install_postgresql_9_4_26.sh
    /tmp/install_postgresql_9_4_26.sh
fi

echo '##### Iniciando configuração #####'

# Diretorios onde devem estar os scripts
DIR1="/etc/zabbix/check_db_pgsql"
# Diretorios onde serão salvos os LOGs
DIR2="/etc/zabbix/check_db_pgsql/logs_backup"

# Criar os diretórios caso não existam.
if [ ! -d "$DIR1" ]; then
  mkdir -p $DIR1
  mkdir -p $DIR2
else 
  DIR1_TMP = "${DIR1}/*"
  DIR2_TMP = "${DIR2}/*"
  rm -rf $DIR1_TMP
  rm -rf $DIR2_TMP
fi

echo '##### Download do arquivo... #####'
# Download dos scripts para a pasta /etc/zabbix/check_db_pgsql/
wget -O /etc/zabbix/check_db_pgsql/verificar_integridade_postgresql.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-integridade-postgresql/verificar_integridade_postgresql.sh
wget -O /etc/zabbix/check_db_pgsql/ler_log_integridade_postgresql.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-integridade-postgresql/ler_log_integridade_postgresql.sh

# Download do arquivo de userparamenter do zabbix para a pasta /etc/zabbix/zabbix_agentd.d/
wget -O /etc/zabbix/zabbix_agentd.d/userparameter_integridade_postgresql.conf https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-integridade-postgresql/userparameter_integridade_postgresql.conf

# Dar permissão de execução aos scripts
chmod +x /etc/zabbix/check_db_pgsql/verificar_integridade_postgresql.sh
chmod +x /etc/zabbix/check_db_pgsql/ler_log_integridade_postgresql.sh

echo '##### Fim Download do arquivo... #####'

# Inserir a linha no cron para executar o script a cada 6 horas iniciando as 02:00
echo "# Executar verificação integridade backup SystemaH" >> /etc/crontab
echo "0 2,8,14,20 * * *   root    /etc/zabbix/check_db_pgsql/verificar_integridade_postgresql.sh systema" >> /etc/crontab

# Reiniciar o serviço do cron
echo '##### Reiniciar cron... #####'
/etc/init.d/cron reload 

# Reiniciar o serviço do Zabbix Agent
echo '##### Reiniciar zabbix-agent... #####'
service zabbix-agent restart

# Executar o script para fazer a primeiras verificação da integridade.
/etc/zabbix/check_db_pgsql/verificar_integridade_postgresql.sh systema
