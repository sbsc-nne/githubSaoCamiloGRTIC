#!/bin/bash

# Defina as configurações do banco de dados
DB_NAME="seu_banco_de_dados"
DB_USER="seu_usuario"
DB_PASSWORD="sua_senha"
BACKUP_DIR="/caminho/do/seu/backup"

# Defina o nome do arquivo de backup
BACKUP_FILE="${BACKUP_DIR}/backup_$(date +%Y%m%d).backup"

# Defina o caminho do arquivo de log
LOG_FILE="${BACKUP_DIR}/log_backup_$(date +%Y%m%d).log"

# Verifique se o arquivo de backup existe
if [ ! -f "$BACKUP_FILE" ]; then
    echo "Erro: O arquivo de backup não foi encontrado." >> "$LOG_FILE"
    exit 1
fi

# Verifique o tamanho do arquivo de backup
MIN_FILE_SIZE=100000 # Ajuste conforme necessário
FILE_SIZE=$(stat -c%s "$BACKUP_FILE")

if [ "$FILE_SIZE" -lt "$MIN_FILE_SIZE" ]; then
    echo "Erro: O tamanho do arquivo de backup é muito pequeno." >> "$LOG_FILE"
    exit 1
fi

# Tente restaurar o backup em um banco de dados temporário
TEMP_DB_NAME="temp_db_for_backup_validation_$(date +%s)"
createdb "$TEMP_DB_NAME"
pg_restore -d "$TEMP_DB_NAME" -U "$DB_USER" -w "$BACKUP_FILE" 2>> "$LOG_FILE"

# Verifique se a restauração foi bem-sucedida
if [ $? -ne 0 ]; then
    echo "Erro: Falha ao restaurar o backup." >> "$LOG_FILE"
    exit 1
fi

# Limpe o banco de dados temporário
dropdb "$TEMP_DB_NAME"

# Se chegou até aqui, o backup foi bem-sucedido
echo "Backup realizado com sucesso." >> "$LOG_FILE"
exit 0
