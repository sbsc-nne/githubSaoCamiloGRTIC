#!/bin/bash
# Data Criação: 04-12-2023
# @Marcelo Grando
# Script para validar a leitura dos backups

# Verifica se foi passado um parâmetro
if [ -z "$1" ]; then
    echo "Por favor, informe o IP da maquina com Zabbix Agent como parametro..."
    exit 1
fi
# Parâmetro 1 - IP da maquina do Zabbix Agenr
IP=$1
echo "Backup Fortes AC"
echo "Nome:     $(zabbix_get -s $IP -p 10050 -k bkp_ac_last_file_name) "
echo "Data:     $(zabbix_get -s $IP -p 10050 -k bkp_ac_last_file_date) "
echo "Tamanho:  $(zabbix_get -s $IP -p 10050 -k bkp_ac_last_file_size) "

echo "Backup Fortes PONTO"
echo "Nome:     $(zabbix_get -s $IP -p 10050 -k bkp_ponto_last_file_name) "
echo "Data:     $(zabbix_get -s $IP -p 10050 -k bkp_ponto_last_file_date) "
echo "Tamanho:  $(zabbix_get -s $IP -p 10050 -k bkp_ponto_last_file_size) "

echo "Backup Fortes RH"
echo "Nome:     $(zabbix_get -s $IP -p 10050 -k bkp_rh_last_file_name) "
echo "Data:     $(zabbix_get -s $IP -p 10050 -k bkp_rh_last_file_date) "
echo "Tamanho:  $(zabbix_get -s $IP -p 10050 -k bkp_rh_last_file_size) "

echo "Backup SystemaH2005"
echo "Nome:   $(zabbix_get -s $IP -p 10050 -k bkp_systema_last_file_name) "
echo "Data:   $(zabbix_get -s $IP -p 10050 -k bkp_systema_last_file_date) "
echo "Tamanho:$(zabbix_get -s $IP -p 10050 -k bkp_systema_last_file_size) "

echo "Backup WKSistemas"
echo "Nome:     $(zabbix_get -s $IP -p 10050 -k bkp_wk_last_file_name) "
echo "Data:     $(zabbix_get -s $IP -p 10050 -k bkp_wk_last_file_date) "
echo "Tamanho:  $(zabbix_get -s $IP -p 10050 -k bkp_wk_last_file_size) "