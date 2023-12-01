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
tamanho=""

for arquivo in "$diretorio"/*"$parte_nome_arquivo"*; do
    if [ -f "$arquivo" ]; then
        # Extrair tamanho do arquivo
        # tamanho=$(du -h "$arquivo" | cut -f1)
        tamanho_em_bytes=$(stat -c "%s" "$arquivo")
        tamanho=$(echo "scale=2; $tamanho_em_bytes / 1024 / 1024" | bc)
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
    echo "$tamanho"
fi