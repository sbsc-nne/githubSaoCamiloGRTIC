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

# Encontrar arquivos no diretório e obter o mais recente
#arquivo_mais_novo=$(ls -1t "$diretorio" | head -n 1)

# Verifica se foi encontrado algum arquivo
if [ -z "$arquivo_mais_novo" ]; then
    echo "Nenhum arquivo encontrado no diretório."
    exit 1
fi

# Obtém informações sobre o arquivo mais novo
tamanho_em_bytes=$(stat -c "%s" "$arquivo_mais_novo")
tamanho_arquivo=$(echo "scale=2; $tamanho_em_bytes / 1024 / 1024" | bc)

#tamanho_arquivo=$(du -h "$diretorio/$arquivo_mais_novo" | cut -f1)
#data_criacao=$(stat --format="%y" "$diretorio/$arquivo_mais_novo")
info=$(stat --format="%Y %y %s" "$arquivo_mais_novo")
timestamp=$(echo $info | cut -d' ' -f1)
data_criacao=$(date -d "@$timestamp" '+%d/%m/%Y %H:%M:%S')

nome_do_arquivo=$(basename "$arquivo_mais_novo")

# Exibe as informações
echo "Arquivo mais recente: $nome_do_arquivo"
echo "Tamanho do arquivo: $tamanho_arquivo"
echo "Data de criação: $data_criacao"