@echo off

set /p "serviceUserName=Digite o nome de usuario para o servico: "
set /p "servicePassword=Digite a senha para o servico: "

echo "== Ocultar a pasta do Zabbix Agent =="
attrib +s +h "C:\zabbix"

echo "== Instalando Zabbix Agent2 como servico. =="
C:\zabbix\zabbix_agent2.exe -i -c C:\zabbix\zabbix_agent2.conf

echo "== Configurando Servico para Rodar com Usuario Especifico =="
sc.exe config "Zabbix Agent 2" obj= ".\%serviceUserName%" password= "%servicePassword%"

echo "== Iniciando Servico Zabbix Agent2 =="
net start "Zabbix Agent 2"