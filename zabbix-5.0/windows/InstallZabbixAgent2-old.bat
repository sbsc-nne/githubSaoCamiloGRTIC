@echo off
echo "== Ocultar a pasta do Zabbix Agent =="
attrib +s +h "C:\zabbix"
echo "== Instalando Zabbix Agent2 como serviço. =="
C:\zabbix\zabbix_agent2.exe -i -c C:\zabbix\zabbix_agent2.conf
echo "== Iniciando Servico Zabbix Agent2 =="

net start "Zabbix Agent 2"