#!/bin/bash
# Data Criação: 17-12-2023
# @Marcelo Grando
# dir = /tmp/install_monitoring.sh
# Script instalar e configurar os monitoramentos:
#   - backup-integridade-postgresql 
#   - backup-monitor-zabbix
#   - version_apps > linux

echo "### Iniciando o download dos arquivos..."

read -p "Informar o numero correspondente a Unidade? 
         ANANINDEUA     = 1
         BALSAS         = 2
         CRATEUS        = 3
         CRATO          = 4
         FORTALEZA      = 5
         ITAPIPOCA      = 6
         LIMOEIRO       = 7
         MACAPA         = 8
         PEDRO II       = 9
         SANTAREM       = 10
         SAO GONCALO    = 11
         TAUA           = 12
         TIANGUA        = 13
         UPA CRATEUS    = 14
         UPA TAUA       = 15
         " flag_continuar;

case $flag_continuar in
    1)
        nomeArquivo="config_backup_monitor_ANA.sh" 
        ;;
    2)
        nomeArquivo="config_backup_monitor_BAL.sh" 
        ;;
    3)
        nomeArquivo="config_backup_monitor_CTU.sh" 
        ;;
    4)
        nomeArquivo="config_backup_monitor_CTO.sh" 
        ;;
    5)
        nomeArquivo="config_backup_monitor_FOR.sh" 
        ;;
    6)
        nomeArquivo="config_backup_monitor_ITP.sh" 
        ;;
    7)
        nomeArquivo="config_backup_monitor_LIM.sh" 
        ;;
    8)
        nomeArquivo="config_backup_monitor_MCP.sh" 
        ;;
    9)
        nomeArquivo="config_backup_monitor_PII.sh" 
        ;;
    10)
        nomeArquivo="config_backup_monitor_STM.sh" 
        ;;
    11)
        nomeArquivo="config_backup_monitor_SGA.sh" 
        ;;
    12)
        nomeArquivo="config_backup_monitor_TAU.sh" 
        ;;
    13)
        nomeArquivo="config_backup_monitor_TNG.sh" 
        ;;
    14)
        nomeArquivo="config_backup_monitor_CTU_UPA.sh" 
        ;;
    15)
        nomeArquivo="config_backup_monitor_TAU_UPA.sh" 
        ;;
    *)
        echo "Unidade não encontrada"
        exit 1
        ;;
esac

read -p "Deseja continuar ConfigBackupMonitor ? Informar 1 = SIM | 2 = NÃO : " flag_continuar;
if [ $flag_continuar = '2' ]
then
    exit 1
fi
# Bloco para baixar e configurar o ConfigBackupMonitor
echo '##### Baixando arquivo do ConfigBackupMonitor #####'
caminhoDestinoBackupMonitor="/tmp/$nomeArquivo"
caminhoOrigemBackupMonitor="https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-monitor-zabbix/$nomeArquivo"
wget -O $caminhoDestinoBackupMonitor $caminhoOrigemBackupMonitor
chmod +x $caminhoDestinoBackupMonitor
echo '##### Iniciando a configuracao do ConfigBackupMonitor #####'
sleep 2
sh $caminhoDestinoBackupMonitor
echo '##### Finalizada a configuracao do ConfigBackupMonitor #####'
sleep 2

read -p "Deseja continuar BackupIntegridadePostgreSQL ? Informar 1 = SIM | 2 = NÃO : " flag_continuar;
if [ $flag_continuar = '2' ]
then
    exit 1
fi
# Bloco para baixar e configurar o BackupIntegridadePostgreSQL
echo '##### Baixando arquivo do BackupIntegridadePostgreSQL #####'
sleep 2
wget -O /tmp/install_verifica_integridade.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/backup-integridade-postgresql/install_verifica_integridade.sh
chmod +x /tmp/install_verifica_integridade.sh
echo '##### Iniciando a configuracao do BackupIntegridadePostgreSQL #####'
sleep 2
sh /tmp/install_verifica_integridade.sh
echo '##### Finalizada a configuracao do BackupIntegridadePostgreSQL #####'

read -p "Deseja continuar VesionAppsFortesRH ? Informar 1 = SIM | 2 = NÃO : " flag_continuar;
if [ $flag_continuar = '2' ]
then
    exit 1
fi
# Bloco para baixar e configurar o VesionAppsFortesRH
echo '##### Baixando arquivo do VesionAppsFortesRH #####'
sleep 2
wget -O /tmp/install_version_fortesrh.sh https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/version_apps/linux/install_version_fortesrh.sh
chmod +x /tmp/install_version_fortesrh.sh
echo '##### Iniciando a configuracao do VesionAppsFortesRH #####'
sleep 2
sh /tmp/install_version_fortesrh.sh
echo '##### Finalizada a configuracao do VesionAppsFortesRH #####'
