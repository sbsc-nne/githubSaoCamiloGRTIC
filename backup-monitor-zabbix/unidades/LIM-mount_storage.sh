#!/bin/bash
# Data Criação: 01-08-2022
# @Marcelo Grando
# Script 

mount -t cifs //10.1.0.43/Backup_Fortes_AC -o 'username=zabbix','password=z4bb1x!@2022',dir_mode=0444,file_mode=0444,nounix  /mnt/bkp_fortes_ac
mount -t cifs //10.1.0.43/Backup_Fortes_Ponto -o 'username=zabbix','password=z4bb1x!@2022',dir_mode=0444,file_mode=0444,nounix  /mnt/bkp_fortes_ponto
mount -t cifs //10.1.0.43/Backup_Bancos/Fortes_RH -o 'username=zabbix','password=z4bb1x!@2022',dir_mode=0444,file_mode=0444,nounix  /mnt/bkp_fortes_rh
mount -t cifs //10.1.0.43/Backup_Bancos/Systema -o 'username=zabbix','password=z4bb1x!@2022',dir_mode=0444,file_mode=0444,nounix  /mnt/bkp_systemah2005
mount -t cifs //10.1.0.43/Backup_WK -o 'username=zabbix','password=z4bb1x!@2022',dir_mode=0444,file_mode=0444,nounix  /mnt/bkp_wk_sistemas