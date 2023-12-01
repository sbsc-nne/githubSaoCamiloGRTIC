#!/bin/bash

# Verifica se foi passado um parâmetro
if [ -z "$1" ]; then
    echo "Por favor, forneça parte do nome do arquivo como parâmetro."
    exit 1
fi

# Diretório específico
diretorio=$1

parte_nome_arquivo=$2
# Busca pelos arquivos no diretório especificado
arquivo_mais_novo=""
data_modificacao=""

for arquivo in "$diretorio"/*"$parte_nome_arquivo"*; do
    if [ -f "$arquivo" ]; then
        # Obter informações do arquivo usando stat
        info=$(stat --format="%Y %y %s" "$arquivo")
        timestamp=$(echo $info | cut -d' ' -f1)
        data_modificacao=$(date -d "@$timestamp" '+%d/%m/%Y %H:%M:%S')
        # Verifica se é o arquivo mais recente
        if [ -z "$arquivo_mais_novo" ] || [ "$data_modificacao" -nt "$(date -r "$arquivo_mais_novo")" ]; then
            arquivo_mais_novo="$arquivo"
        fi
    fi
done

# Exibe informações do arquivo mais recente
if [ -z "$arquivo_mais_novo" ]; then
    echo "Nenhum arquivo encontrado com o padrão fornecido."
else
    echo "$(basename "$arquivo_mais_novo")"
fi