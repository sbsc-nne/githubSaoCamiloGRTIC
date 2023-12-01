#!/bin/bash
# Data Criação: 01-12-2023
# @Marcelo Grando
# Script para retornar a data de criação do ultimo arquivo em uma determinada pasta.

# Verifica se foi passado um parâmetro
if [ -z "$1" ]; then
    echo "Por favor, forneça parte do nome do arquivo como parâmetro."
    exit 1
fi
# Parâmetro 1 - Diretório específico
diretorio=$1
# Parâmetro 2 - parte do nome do arquivo  
parte_do_nome=$2
# Verifica se o diretório existe
if [ ! -d "$diretorio" ]; then
    echo "Diretório não encontrado: $diretorio"
    exit 1
fi

# Encontrar arquivos correspondentes e obter o mais recente
arquivo_mais_novo=$(ls -1t "$diretorio"/*"$parte_do_nome"* 2>/dev/null | head -n 1)

# Verifica se foi encontrado algum arquivo
if [ -z "$arquivo_mais_novo" ]; then
    echo "Nenhum arquivo encontrado no diretório."
    exit 1
fi

nome_do_arquivo=$(basename "$arquivo_mais_novo")

# Exibe as informações
echo "$nome_do_arquivo"