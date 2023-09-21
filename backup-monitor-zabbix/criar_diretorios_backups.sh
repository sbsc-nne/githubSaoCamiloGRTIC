#!/bin/bash
# Data Criação: 01-08-2022
# @Marcelo Grando
# Script criar_diretorio_backups.sh


DIR_01="/mnt/bkp_fortes_ac"  # Substitua com o caminho do diretório desejado
DIR_02="/mnt/bkp_fortes_ponto"  # Substitua com o caminho do diretório desejado
DIR_03="/mnt/bkp_fortes_rh"  # Substitua com o caminho do diretório desejado
DIR_04="/mnt/bkp_systemah2005"  # Substitua com o caminho do diretório desejado
DIR_05="/mnt/bkp_wk_sistemas"  # Substitua com o caminho do diretório desejado

if [ ! -d "$DIR_01" ]; then
    mkdir -p "$DIR_01" && chmod 777 -R $DIR_01
fi

if [ ! -d "$DIR_02" ]; then
    mkdir -p "$DIR_02" && chmod 777 -R $DIR_02
fi

if [ ! -d "$DIR_03" ]; then
    mkdir -p "$DIR_03" && chmod 777 -R $DIR_03
fi

if [ ! -d "$DIR_04" ]; then
    mkdir -p "$DIR_04" && chmod 777 -R $DIR_04
fi

if [ ! -d "$DIR_05" ]; then
    mkdir -p "$DIR_05" && chmod 777 -R $DIR_05
fi
