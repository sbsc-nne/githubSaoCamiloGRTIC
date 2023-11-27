#!/bin/bash
# Data Criação: 24-11-2023
# @Marcelo Grando
# dir /home/check_db_pgsql
# Script verificar_integridade_postgresql.sh


### INICIO - COPIAR ULTIMO BACKUP PARA MAQUINA LOCAL ###
# Verifica se foi fornecido o parâmetro com as iniciais do nome do arquivo
if [ $# -eq 0 ]; then
  echo "Por favor, forneça as iniciais do nome do arquivo como argumento."
  exit 1
fi

# Definir nome arquivo de log
#data_verficacao=$(date +"%Y/%m/%d %H:%M:%S")
#hoje=$(date +"%Y_%m_%d_%H_%M_%S")
#nomearquivo=log_backup-$hoje.log

# Diretório de origem
diretorio_origem="/home/check_db_pgsql/logs_backup"

iniciais=$1

dado_return=$2
# Constrói o padrão do arquivo usando as iniciais
padrao_arquivo="${iniciais}*"

listar_arquivos="${diretorio_origem}/${padrao_arquivo}"

# Encontra o arquivo mais recente no diretório
arquivo_mais_recente=$(ls -t ${diretorio_origem}/${padrao_arquivo} 2>/dev/null | head -n 1)

# Verifica se encontrou algum arquivo
if [ -z "$arquivo_mais_recente" ]; then
  echo "Nenhum arquivo encontrado com as iniciais fornecidas."
  exit 1
fi
# Retornar parametro 1 = Status 
if [ "$dado_return" == 1 ]; then
    cat $arquivo_mais_recente | grep CHECKLIST_INTEGRIDADE | awk '{print $2}'
fi

# Retornar parametro 2 = Data Hora 
if [ "$dado_return" == 2 ]; then
    cat $arquivo_mais_recente | grep CHECKLIST_INTEGRIDADE | awk '{print $3" "$4}'
fi

# Retornar parametro 3 = Nome do arquivo de backup verificado
if [ "$dado_return" == 3 ]; then
    cat $arquivo_mais_recente | grep CHECKLIST_INTEGRIDADE | awk '{print $5}'
fi

#cat $arquivo_mais_recente | grep CHECKLIST_INTEGRIDADE | awk '{print $1}'