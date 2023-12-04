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

echo "Backup Fortes AC - Nome:      $(zabbix_get -s $IP -p 10050 -k bkp_ac_last_file_name) "
echo "Backup Fortes AC - Data:      $(zabbix_get -s $IP -p 10050 -k bkp_ac_last_file_date) "
echo "Backup Fortes AC - Tamanho:   $(zabbix_get -s $IP -p 10050 -k bkp_ac_last_file_size) "

echo "Backup Fortes PONTO - Nome:   $(zabbix_get -s $IP -p 10050 -k bkp_ponto_last_file_name) "
echo "Backup Fortes PONTO - Data:   $(zabbix_get -s $IP -p 10050 -k bkp_ponto_last_file_date) "
echo "Backup Fortes PONTO - Tamanho:$(zabbix_get -s $IP -p 10050 -k bkp_ponto_last_file_size) "

echo "Backup Fortes RH - Nome:      $(zabbix_get -s $IP -p 10050 -k bkp_rh_last_file_name) "
echo "Backup Fortes RH - Data:      $(zabbix_get -s $IP -p 10050 -k bkp_rh_last_file_date) "
echo "Backup Fortes RH - Tamanho:   $(zabbix_get -s $IP -p 10050 -k bkp_rh_last_file_size) "

echo "Backup SystemaH2005 - Nome:   $(zabbix_get -s $IP -p 10050 -k bkp_systema_last_file_name) "
echo "Backup SystemaH2005 - Data:   $(zabbix_get -s $IP -p 10050 -k bkp_systema_last_file_date) "
echo "Backup SystemaH2005 - Tamanho:$(zabbix_get -s $IP -p 10050 -k bkp_systema_last_file_size) "

echo "Backup WKSistemas - Nome:     $(zabbix_get -s $IP -p 10050 -k bkp_wk_last_file_name) "
echo "Backup WKSistemas - Data:     $(zabbix_get -s $IP -p 10050 -k bkp_wk_last_file_date) "
echo "Backup WKSistemas - Tamanho:  $(zabbix_get -s $IP -p 10050 -k bkp_wk_last_file_size) "