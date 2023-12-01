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
descricao_completa=""

for arquivo in "$diretorio"/*"$parte_nome_arquivo"*; do
    if [ -f "$arquivo" ]; then
        # Obter informações do arquivo usando stat
        info=$(stat --format="%Y %y %s" "$arquivo")
        
        # Extrair data e hora do timestamp
        timestamp=$(echo $info | cut -d' ' -f1)
        data_modificacao=$(date -d "@$timestamp" '+%d/%m/%Y %H:%M:%S')
        #data_modificacao=$(stat --format="%m-%d-%y %H-%M" "$arquivo")
        #data_modificacao=$(date -r "$arquivo")
        tamanho=$(du -h "$arquivo" | cut -f1)
        descricao_completa=$(file "$arquivo")

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
    #echo "Arquivo mais recente:"
    echo "Nome: $(basename "$arquivo_mais_novo")"
    #echo "Descrição completa: $descricao_completa"
    echo "Tamanho: $tamanho"
    echo "Data de criação: $data_modificacao"
fi