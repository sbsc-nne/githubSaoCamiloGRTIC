#!/bin/bash
# Data Criação: 01-08-2022
# Data Alteração: 28-09-2023
# @Marcelo Grando
# Script 

mount -t cifs //192.168.10.50/Volume_1/Backup_FortesAC /mnt/bkp_fortes_ac -o username=zabbix,password=<senha>,vers=1.0
mount -t cifs //192.168.10.50/Volume_1/Backup_FortesPonto /mnt/bkp_fortes_ponto -o username=zabbix,password=<senha>,vers=1.0
mount -t cifs //192.168.10.50/Volume_1/Backup_FortesRH /mnt/bkp_fortes_rh -o username=zabbix,password=<senha>,vers=1.0
mount -t cifs //192.168.10.50/Volume_1/Backup_SystemaH /mnt/bkp_systemah2005 -o username=zabbix,password=<senha>,vers=1.0
mount -t cifs //192.168.10.50/Volume_1/Backup_WKSistemas /mnt/bkp_wk_sistemas -o username=zabbix,password=<senha>,vers=1.0