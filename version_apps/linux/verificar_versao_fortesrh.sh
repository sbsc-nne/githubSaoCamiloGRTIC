#!/bin/bash
# Data Criação: 06-12-2023
# @Marcelo Grando
# dir = /etc/zabbix/scripts/verificar_versao_fortesrh.sh
# Script verificar versão do FortesRH.

# Verifica se foi fornecido o parâmetro com as iniciais do nome do arquivo
if [ $# -eq 0 ]; then
  echo "Por favor, informar o parametro"
  exit 1
fi

dado_return=$1

# Configurações do banco de dados
DB_HOST="0.0.0.0"
DB_PORT="5432"
DB_NAME="fortesrh"
DB_USER="saocamilo"
DB_PASSWORD=""

if [ "$dado_return" == 1 ]; then
  # Comando SQL SELECT
  SQL_QUERY="select versao as versao_forte_rh from parametrosdosistema;"
  # Executa a consulta e armazena o resultado na variável
  resultado=$(psql -h $DB_HOST -p $DB_PORT -d $DB_NAME -U $DB_USER -c "$SQL_QUERY" -tA)
fi

if [ "$dado_return" == 2 ]; then
  # Comando SQL SELECT
  SQL_QUERY="select acversaowebservicecompativel as versao_ws_compat from parametrosdosistema;"
  # Executa a consulta e armazena o resultado na variável
  resultado=$(psql -h $DB_HOST -p $DB_PORT -d $DB_NAME -U $DB_USER -c "$SQL_QUERY" -tA)
fi

# Exibe o resultado
echo "$resultado"