echo "Instalando Zabbix Agent2 como serviço."
C:\zabbix\zabbix_agent2.exe -i -c C:\zabbix\zabbix_agent2.conf
echo "Iniciando Servico Zabbix Agent2"
net start "Zabbix Agent 2"
