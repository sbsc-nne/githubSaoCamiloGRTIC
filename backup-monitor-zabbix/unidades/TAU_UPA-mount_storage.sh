#!/bin/bash
# Data Criação: 01-08-2022
# @Marcelo Grando
# Script 

mount -t cifs //192.168.1.122/Backup_FortesAC -o 'username=zabbix','password=<senha>',dir_mode=0555,file_mode=0555,nounix  /mnt/bkp_fortes_ac
mount -t cifs //192.168.1.122/Backup_FortesPonto -o 'username=zabbix','password=<senha>',dir_mode=0555,file_mode=0555,nounix  /mnt/bkp_fortes_ponto
mount -t cifs //192.168.1.122/Backup_FortesRH -o 'username=zabbix','password=<senha>',dir_mode=0555,file_mode=0555,nounix  /mnt/bkp_fortes_rh
mount -t cifs //192.168.1.122/Backup_SystemaH -o 'username=zabbix','password=<senha>',dir_mode=0555,file_mode=0555,nounix  /mnt/bkp_systemah2005
mount -t cifs //192.168.1.122/Backup_WKSistemas -o 'username=zabbix','password=<senha>',dir_mode=0555,file_mode=0555,nounix  /mnt/bkp_wk_sistemas