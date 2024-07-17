#!/bin/bash
# Data criacao: 01-11-2022
# @Marcelo Grando
# Atualizando sistema FortesRH

echo "## ATENCAO ## O arquivo fortesrh.war deve estar no servidor na pasta /home/administrador"
read -p "Deseja continuar? Informar 1 = SIM | 2 = NAO : " flag_continuar;
if [ $flag_continuar = '1' ]
then
    echo '##### Iniciando atualizacao do FortesRH #####'
    sleep 5s

    echo '##### Parando o servico do Tomcat #####'
    sudo systemctl stop tomcat
    sleep 5s

    echo '##### Copiando o novo arquivo #####'
    sudo rm -rf /opt/tomcat/webapps/fortesrh_bak/
    sudo rm -rf /opt/tomcat/webapps/fortesrh.war.bak
    sudo mv /opt/tomcat/webapps/fortesrh.war /opt/tomcat/webapps/fortesrh.war.bak
    sudo mv /opt/tomcat/webapps/fortesrh /opt/tomcat/webapps/fortesrh_bak
    sudo mv /home/administrador/fortesrh.war /opt/tomcat/webapps/
    sleep 5s

    echo '##### Limpando os logs do Tomcat #####'
    sudo rm -rf /opt/tomcat/logs/*
    sleep 5s

    echo '##### Iniciando o servico do Tomcat #####'
    sudo systemctl start tomcat
    sleep 2s
    echo '##### Atualizacao finalizado com sucesso!!! #####'
    sleep 5s
    tail -f /opt/tomcat/logs/catalina.out
else
    echo "## ATUALIZACAO ABORTADA!!! :-( ##"
fi