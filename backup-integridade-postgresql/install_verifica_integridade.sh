#!/bin/bash
# Data Criação: 27-11-2023
# @Marcelo Grando
# dir = /tmp/install_verifica_integridade.sh
# Script instalar e configurar a validação de integridade do Backup do SystemaH
clear

# Verifica se o PostgreSQL está instalado
if dpkg -l | grep -q postgresql; then
  echo "O PostgreSQL está instalado."
else
  # Pergunta se o usuário deseja instalar o PostgreSQL
  read -p "O PostgreSQL não está instalado. Deseja instalá-lo? (y/n): " choice
  if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    # Adiciona o repositório do PostgreSQL 9.4
    sudo apt-get update -y && sudo apt-get upgrade -y
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql-pgdg.list > /dev/null
    
    # Atualiza a lista de pacotes e instala o PostgreSQL 9.4
    sudo apt-get update -y
    sudo apt-get install postgresql-9.4 -y
    sudo service postgresql stop
    sudo update-rc.d postgresql disable
  else
    echo "Você optou por não instalar o PostgreSQL."
  fi
fi


echo '##### Iniciando configuração #####'

# Diretorios onde devem estar os scripts
DIR1="/etc/zabbix/check_db_pgsql"
# Diretorios onde serão salvos os LOGs
DIR2="/etc/zabbix/check_db_pgsql/logs_backup"

# Criar os diretórios caso não existam, caso existam limpar.
if [ ! -d "$DIR1" ]; then
  mkdir -p $DIR1
  mkdir -p $DIR2
else 
  rm -rf "$DIR1"/*
  mkdir -p $DIR2
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
