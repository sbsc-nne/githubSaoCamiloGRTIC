#!/bin/bash
# Data Criação: 09-07-2024
# @Marcelo Grando
# 1 - Script instalar e configurar o xwiki 15.10.10 em um Banco PostgreSQL, usando JETTY 10:

# Instalar JAVA
sudo apt install default-jre -y
java --version

# Criar diretórios
mkdir /opt/java
mkdir /opt/java/jetty-base
# Baixar o JETTY 10.0.21
cd /opt/java
wget https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-home/10.0.21/jetty-home-10.0.21.tar.gz
# Extrair o JETTY 10.0.21
tar -zxvf jetty-home-10.0.21.tar.gz
rm jetty-home-10.0.21.tar.gz
# Criar Variavel de Ambiente
export JETTY_HOME=/opt/java/jetty-home-10.0.21
# Acessar a pasta jetty-base e instalar os modulos
cd /opt/java/jetty-base
java -jar $JETTY_HOME/start.jar --add-module=server,http,deploy
java -jar $JETTY_HOME/start.jar --add-module=demo
java -jar $JETTY_HOME/start.jar
# Instalar o PostgreSQL
apt install postgresql -y
# Acessar o Postgres
sudo su postgres
psql
# Criar usuário, banco e dar permissão
create user xwiki password '<informar_a_senha>';
create database xwiki with owner=xwiki;
grant all on schema public to xwiki;
\q
exit
# Acessar o banco de dados 
PGPASSWORD='<informar_a_senha>' psql -h localhost -U xwiki -d xwiki
# Listar os bancos de dados, confereir se tem o banco criado com UTF8 e owner xwiki
\l
\q

# Baixar o arquivo war do xwiki
sudo apt-get install unzip -y
cd /tmp
wget https://nexus.xwiki.org/nexus/content/groups/public/org/xwiki/platform/xwiki-platform-distribution-war/15.10.10/xwiki-platform-distribution-war-15.10.10.war
#wget https://nexus.xwiki.org/nexus/content/groups/public/org/xwiki/platform/xwiki-platform-distribution-war/16.5.0/xwiki-platform-distribution-war-16.5.0.war
unzip xwiki-platform-distribution-war-15.10.10.war -d /opt/java/jetty-base/webapps/xwiki/
#unzip xwiki-platform-distribution-war-16.5.0.war -d /opt/java/jetty-base/webapps/xwiki/
# Baixar o drive JDBC PostgreSQL

cd /tmp
wget https://jdbc.postgresql.org/download/postgresql-42.7.3.jar
mv postgresql-42.7.3.jar /opt/java/jetty-base/webapps/xwiki/WEB-INF/lib/

# Configurar o hibernate.cfg.xml 
vi /opt/java/jetty-base/webapps/xwiki/WEB-INF/hibernate.cfg.xml

# Será necessário comentar o codigo na parte "<!--  Configuration for the default database."
# Remover comentário para habilitar o " <!-- PostgreSQL configuration."
# Alterar a senha do usuário no banco

# Criar diretorios
mkdir /var/lib/xwiki
chown root:root /var/lib/xwiki
mkdir /var/lib/xwiki/data

# Editar as propriedades do xwiki.properties
vi /opt/java/jetty-base/webapps/xwiki/WEB-INF/xwiki.properties

# Remover o comentário da linha
# environment.permanentDirectory = /var/lib/xwiki/data/

# Alterar o arquivo server.ini
vi /opt/java/jetty-base/start.d/server.ini

#Altera a linha # jetty.httpConfig.uriCompliance=DEFAULT
# Descomentar e mudar valor para 
...
jetty.httpConfig.uriCompliance=RFC3986
...
# Salvar o arquivo server.ini

# Executar o jetty
cd /opt/java/jetty-base
java -jar $JETTY_HOME/start.jar

# 1 - FIM

# ------------------------------------------------------------------------------------
# 2 - Iniciar o Jetty 10 como serviço no Ubuntu 24.04, você pode criar um serviço systemd
# ------------------------------------------------------------------------------------

# Adicione a variável de ambiente JETTY_HOME ao arquivo /etc/environment 
#   para que ela seja carregada globalmente:
sudo vi /etc/environment

# Adicione a linha:
JETTY_HOME=/opt/java/jetty-home-10.0.21

#Carregue as variáveis de ambiente:
source /etc/environment

# Crie um script chamado start-jetty.sh em /Java/jetty-base:
sudo vi /opt/java/jetty-base/start-jetty.sh

# Adicione o seguinte conteúdo ao script:
# ---- INICIO - start-jetty.sh
#!/bin/bash
JETTY_HOME=/opt/java/jetty-home-10.0.21
cd /opt/java/jetty-base
java -jar $JETTY_HOME/start.jar
# ---- FIM - start-jetty.sh

# Torne o script executável:
sudo chmod +x /opt/java/jetty-base/start-jetty.sh

# Crie um arquivo de serviço systemd para Jetty:
sudo vi /etc/systemd/system/jetty.service

# Adicione o seguinte conteúdo ao arquivo:
# ---- INICIO - jetty.service
[Unit]
Description=Jetty 10 Web Server
After=network.target

[Service]
Type=simple
Environment=JETTY_HOME=/opt/java/jetty-home-10.0.21
WorkingDirectory=/opt/java/jetty-base
ExecStart=/bin/bash /opt/java/jetty-base/start-jetty.sh
User=root
Group=root
Restart=on-failure

[Install]
WantedBy=multi-user.target
# ---- FIM - jetty.service

# Recarregue o systemd para reconhecer o novo serviço:
sudo systemctl daemon-reload

# Inicie o serviço Jetty:
sudo systemctl start jetty

# Habilite o serviço para iniciar no boot:
sudo systemctl enable jetty

# Verificar o status do serviço
sudo systemctl status jetty

# 2 - FIM

# ------------------------------------------------------------------------------------
# 3 - Configurar um proxy reverso com HTTPS usando o Apache para um servidor Jetty 
# é uma ótima maneira de direcionar o tráfego seguro para o Jetty a partir do Apache.
# ------------------------------------------------------------------------------------

# Instale o Apache (caso ainda não esteja instalado)
sudo apt-get update
sudo apt-get install apache2

# Habilite os módulos necessários no Apache
sudo a2enmod proxy proxy_http ssl

# Crie um arquivo de configuração para o proxy reverso. Por exemplo, 
# crie um arquivo chamado jetty-proxy.conf em /etc/apache2/sites-available/:
sudo vi /etc/apache2/sites-available/jetty-proxy.conf

# Adicione o seguinte conteúdo ao arquivo jetty-proxy.conf (ajuste os detalhes conforme necessário)
# Certifique-se de substituir seu_dominio.com, 
# /caminho/para/seu/certificado.crt e /caminho/para/sua/chave-privada.key pelos valores reais.

<VirtualHost *:443>
    ServerName seu_dominio.com

    SSLEngine on
    SSLCertificateFile /caminho/para/seu/certificado.crt
    SSLCertificateKeyFile /caminho/para/sua/chave-privada.key

    ProxyPass / http://localhost:8080/
    ProxyPassReverse / http://localhost:8080/
</VirtualHost>

# Ative o arquivo de configuração e reinicie o Apache:
sudo a2ensite jetty-proxy.conf
sudo systemctl restart apache2

# Certifique-se de que o Jetty esteja ouvindo na porta 8080 
# (ou a porta que você especificou no arquivo de configuração).

# 3 - FIM