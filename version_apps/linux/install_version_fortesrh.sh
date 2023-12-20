#!/bin/bash
# Data Criação: 06-12-2023
# @Marcelo Grando
# dir = /tmp/install_version_fortesrh.sh
# Script instalar e configurar leitura da versão do FortesRH.

# Verifica se foi fornecido o parâmetro com as iniciais do nome do arquivo
clear

read -p "Informar o IP do servidor do FortesRH : " ip_server_fortesrh;

echo "## ATENÇÃO ## O IP: $ip_server_fortesrh é o do servidor do FortesRH está correto?"
read -p "Informar 1 = SIM | 2 = NÃO : " flag_continuar;
if [ $flag_continuar = '2' ]
then
    echo '## Execute o script novamente informando como parametro o IP Correto ##'
    exit 1
fi

#!/bin/bash

# Verifica se o PostgreSQL está instalado
if dpkg -l | grep -q postgresql; then
  echo "O PostgreSQL está instalado."
else
  # Pergunta se o usuário deseja instalar o PostgreSQL
  read -p "O PostgreSQL não está instalado. Deseja instalá-lo? (y/n): " choice
  if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    # Adiciona o repositório do PostgreSQL 9.4
    sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

    # Atualiza a lista de pacotes e instala o PostgreSQL 9.4
    sudo apt-get update
    sudo apt-get install postgresql-9.4
  else
    echo "Você optou por não instalar o PostgreSQL."
  fi
fi


# Configurações do banco de dados
DB_HOST=$ip_server_fortesrh
DB_PORT="5432"
DB_NAME="fortesrh"
DB_USER="postgres"
DB_PASSWORD=""

# Comando SQL SELECT
SQL_QUERY1="CREATE ROLE saocamilo LOGIN ENCRYPTED PASSWORD 'md595238e0009cafda70223e6760c42f87d' NOSUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;"

SQL_QUERY2="GRANT SELECT ON TABLE public.parametrosdosistema to saocamilo;"

# Executa o comando psql
#psql -h $DB_HOST -p $DB_PORT -d $DB_NAME -U $DB_USER -W $DB_PASSWORD -c "$SQL_QUERY"
echo '## Criando usuário e permitindo GRANT SELECT na tabela... ##'
# Executa a consulta e armazena o resultado na variável
psql -h $DB_HOST -p $DB_PORT -d $DB_NAME -U $DB_USER -c "$SQL_QUERY1"
psql -h $DB_HOST -p $DB_PORT -d $DB_NAME -U $DB_USER -c "$SQL_QUERY2"

echo '## Baixando os arquivos de configuração... ##'
# Baixar os arquivos de configuração
wget -O /etc/zabbix/script/verificar_versao_fortesrh.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/version_apps/linux/verificar_versao_fortesrh.sh
wget -O /etc/zabbix/zabbix_agentd.d/userparameter_info_version_fortesrh.conf https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/version_apps/linux/userparameter_info_version_fortesrh.conf

chmod 777 /etc/zabbix/script/verificar_versao_fortesrh.sh

sleep 3

sed "s/192.168.0.245/$ip_server_fortesrh/" /etc/zabbix/script/verificar_versao_fortesrh.sh

sudo systemctl restart zabbix-agent

echo '## Finalizado... ##'

