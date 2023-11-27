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

