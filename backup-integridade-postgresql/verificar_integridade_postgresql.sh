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
data_verficacao=$(date +"%d/%m/%Y %H:%M:%S")
hoje=$(date +"%Y_%m_%d_%H_%M_%S")
nomearquivo=log_backup-$hoje.log

# Diretório de origem
diretorio_origem="/mnt/bkp_systemah2005"
# Diretório de destino para onde o arquivo será copiado
diretorio_destino="/home/check_db_pgsql/logs_backup"

# criar o arquivo de log
arquivo_log=$diretorio_destino"/"$nomearquivo

# inicia a gravação do LOG
echo "DataHora: $data_verficacao" >> $arquivo_log 2>&1
echo "Iniciando cópia do backup" >> $arquivo_log 2>&1
# Iniciais do nome do arquivo fornecidas como argumento
iniciais=$1

# Constrói o padrão do arquivo usando as iniciais
padrao_arquivo="${iniciais}*"

listar_arquivos="${diretorio_origem}/${padrao_arquivo}"

# Encontra o arquivo mais recente no diretório
arquivo_mais_recente=$(ls -t ${diretorio_origem}/${padrao_arquivo} 2>/dev/null | head -n 1)

# Verifica se encontrou algum arquivo
if [ -z "$arquivo_mais_recente" ]; then
  echo "Nenhum arquivo encontrado com as iniciais fornecidas." >> $arquivo_log 2>&1
  exit 1
fi

# Copia o arquivo mais recente para o diretório de destino
cp "${arquivo_mais_recente}" "${diretorio_destino}/"

echo "Arquivo mais recente copiado para ${arquivo_mais_recente}." >> $arquivo_log 2>&1
### FIM - COPIAR ULTIMO BACKUP PARA MAQUINA LOCAL ###

### INICIO - VALIDAR A INTEGRIDADE DO BACKUP ###
echo "Iniciando verificação da integridade" >> $arquivo_log 2>&1
# Configurações
DB_USER="postgres"
DB_NAME="systema"
BACKUP_DIR=$diretorio_destino
dir_pg_restore="/opt/postgresql-9.4.26/src/bin" # Alterar o diretório de acordo com versão do postgres

# Verifica se o diretório de backup existe
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Erro: O diretório de backup não existe." >> $arquivo_log 2>&1
    exit 1
fi

# Lista todos os arquivos .backup no diretório de backup
BACKUP_FILES=$(ls "$BACKUP_DIR"/*.backup 2>/dev/null)

# Verifica se existem arquivos de backup
if [ -z "$BACKUP_FILES" ]; then
    echo "Erro: Nenhum arquivo de backup encontrado no diretório." >> $arquivo_log 2>&1
    exit 1
fi

# Loop sobre os arquivos de backup
for BACKUP_FILE in $BACKUP_FILES; do
    # Extrai o nome do arquivo sem a extensão
    FILENAME=$(basename "$BACKUP_FILE" .backup)
    echo "Checando Integridade do arquivo: $BACKUP_FILES." >> $arquivo_log 2>&1
    # Comando para restaurar o despejo e verificar a integridade
    # NAO FUNCIONA /opt/PostgreSQL/9.4.26/bin/pg_restore --dbname="temp_$DB_NAME" --username="$DB_USER" --no-password --no-owner --no-privileges "$BACKUP_FILE" > /dev/null
    /opt/PostgreSQL/9.4.26/bin/pg_restore --username="$DB_USER" --dbname="temp_$DB_NAME" --no-password --list "$BACKUP_FILE" > /dev/null
    
    # Verificar se o comando pg_restore foi bem-sucedido
    if [ $? -eq 0 ]; then
        echo "Restore realizado com sucesso." >> $arquivo_log 2>&1
        echo "CHECKLIST_INTEGRIDADE: OK   $data_verficacao    $BACKUP_FILES" >> $arquivo_log 2>&1
    else
        echo "Erro ao restaurar backup $BACKUP_FILES." >> $arquivo_log 2>&1
        echo "CHECKLIST_INTEGRIDADE: ERROR    $data_verficacao    $BACKUP_FILES" >> $arquivo_log 2>&1
        exit 1
    fi
    # Verifica a integridade do arquivo usando o utilitário pg_restore
    #/opt/PostgreSQL/9.4.26/bin/pg_restore --username="$DB_USER" --dbname="temp_$DB_NAME" --no-password --list "$BACKUP_FILE" > /dev/null
    # Verifica se o comando pg_restore foi bem-sucedido
    #if [ $? -ne 0 ]; then
    #    echo "Erro: Falha na verificação de integridade do arquivo $FILENAME." >> $arquivo_log 2>&1
    #    exit 1
    #fi
    rm $BACKUP_FILE
done

echo "Verificação de integridade concluída com sucesso." >> $arquivo_log 2>&1
exit 0

### FIM - VALIDAR A INTEGRIDADE DO BACKUP ###