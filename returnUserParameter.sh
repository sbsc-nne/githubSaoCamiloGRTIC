#!/bin/bash
# Data Criação: 17-12-2023
# @Marcelo Grando
# dir = /etc/zabbix/script/resultUserParameter.sh
# Script validar o retorno dos parametros do UserParameter:
#   - backup-integridade-postgresql 
#   - backup-monitor-zabbix
#   - version_apps > linux

# Obtém o endereço IP do servidor da VLAN10
ipZabbixProxy=$(ifconfig | grep 10.21 | awk '{print $2}')

echo "Backups Fortes AC"
zabbix_get -s $ipZabbixProxy -k bkp_ac_last_file_name
zabbix_get -s $ipZabbixProxy -k bkp_ac_last_file_date
zabbix_get -s $ipZabbixProxy -k bkp_ac_last_file_size
echo "Backups Fortes Ponto"
zabbix_get -s $ipZabbixProxy -k bkp_ponto_last_file_name
zabbix_get -s $ipZabbixProxy -k bkp_ponto_last_file_date
zabbix_get -s $ipZabbixProxy -k bkp_ponto_last_file_size
echo "Backups FortesRH"
zabbix_get -s $ipZabbixProxy -k bkp_rh_last_file_name
zabbix_get -s $ipZabbixProxy -k bkp_rh_last_file_date
zabbix_get -s $ipZabbixProxy -k bkp_rh_last_file_size
echo "Backups SystemaH"
zabbix_get -s $ipZabbixProxy -k bkp_systema_last_file_name
zabbix_get -s $ipZabbixProxy -k bkp_systema_last_file_date
zabbix_get -s $ipZabbixProxy -k bkp_systema_last_file_size
echo "Backups WK"
zabbix_get -s $ipZabbixProxy -k bkp_wk_last_file_name
zabbix_get -s $ipZabbixProxy -k bkp_wk_last_file_date
zabbix_get -s $ipZabbixProxy -k bkp_wk_last_file_size
echo "Espaço disponivel em disco Storage"
zabbix_get -s $ipZabbixProxy -k size_used_storage
echo "Integridade DB SystemaH"
zabbix_get -s $ipZabbixProxy -k status_check_integridade
zabbix_get -s $ipZabbixProxy -k datetime_check_integridade
zabbix_get -s $ipZabbixProxy -k filename_check_integridade
echo "Versão do FortesRH"
zabbix_get -s $ipZabbixProxy -k version_fortes_rh
zabbix_get -s $ipZabbixProxy -k version_ws_compativel