#instalacao do postgres em Servidores Ubuntu Server 20.04
PG_START=/etc/init.d/postgresql-9.4.26
PG_CONFIG=/opt/PostgreSQL/9.4.26/data/postgresql.conf
PG_HBA=/opt/PostgreSQL/9.4.26/data/pg_hba.conf
PG_PSQL=/opt/PostgreSQL/9.4.26/bin/psql
PG_RECURSO=/opt/postgresql-9.4.26/contrib/
PG_EXTENSION=/opt/PostgreSQL/9.4.26/share/postgresql/extension/
PG_DOCUMENTOS=/opt/PostgreSQL/9.4.26/data/
PG_PORT="5432"
PG_MAX_CONN="200"
PG_USER="postgres"
PG_ADDRESS="0.0.0.0 0.0.0.0"

#para iniciar o serviço automaticamente ao ligar o servidor
#vi /etc/crontab
#@reboot     root    /etc/init.d/postgresql-9.4.26 start

#LIMPA A CONSOLE
clear

#ATUALIZA O apt-get
apt-get update -y
#FAZ DOWNLOAD DA INSTALAÇÃO DO BANCO DE DADOS
wget https://ftp.postgresql.org/pub/source/v9.4.26/postgresql-9.4.26.tar.gz
#wget download.systemaonline.com.br/systema/postgresql/linux/postgresql-9.4.26.tar.gz
#DESCOMPACTA A INSTALAÇÃO DO BANCO DE DADOS
tar xvfz postgresql-9.4.26.tar.gz

#BAIXA AS DEPENDENCIAS
apt-get install libxml2++-* -y
apt-get install libxml++2* -y
apt-get install *libxml2* -y
apt-get install zlib1g-dev -y
apt-get install libxml2-dev -y
apt-get install gcc -y
apt-get install make -y
apt-get install uuid -y
apt-get install libossp-uuid-dev -y



#COPIA O ARQUIVO DE INICIALIZAÇÃO PARA A PASTA PADRÃO
cp postgresql-9.4.26/contrib/start-scripts/linux $PG_START
chmod o+x $PG_START

#MODIFICA AS CONFIGURAÇÕES DO ARQUIVO DE INICIALIZAÇÃO
sed -i -e"s/^prefix=\\/usr\\/local\\/pgsql.*$/prefix=\\/opt\\/PostgreSQL\\/9.4.26/" $PG_START
sed -i -e"s/^PGDATA=\"\\/usr\\/local\\/pgsql\\/data\".*$/PGDATA=\"\\/opt\\/PostgreSQL\\/9.4.26\\/data\"/" $PG_START

#CONFIGURA A INSTALAÇÃO DO BANCO DE DADOS
cd postgresql-9.4.26
#./configure --prefix=/opt/PostgreSQL/9.4.26 --without-readline --with-libxml && make && make install
./configure --prefix=/opt/PostgreSQL/9.4.26 --without-readline --with-libxml --with-ossp-uuid && make -j8 -s install

#ADICIONA O GRUPO E USUÁRIO
groupadd postgres
useradd postgres -g postgres

mkdir /home/postgres
chown postgres:postgres /home/postgres

#CRIA A PASTA DE DADOS
mkdir /opt/PostgreSQL/9.4.26/data
chown -R postgres:postgres /opt/PostgreSQL/9.4.26/data

#INSTALA O SUPORTE AO ENCODING PADRÃO
sudo locale-gen en_US en_US.UTF-8
sudo locale-gen pt_BR pt_BR.UTF-8
export LC_ALL="pt_BR.UTF-8"
export LC_CTYPE="pt_BR.UTF-8"

#INSTALA O RECURSO DO DBLINK
#cd /opt/postgresql-9.4.26/contrib/dblink/
cd $PG_RECURSO 
cd dblink/
make && make install

#INSTALA O RECURSO DE TABELAS EM CACHE
cd $PG_RECURSO
cd pg_prewarm/
make && make install

#INSTALA O RECURSO DE FUNÇÕES PARA COMPARAÇÃO DE TEXTOS POR APROXIMAÇÃO
cd $PG_RECURSO
cd pg_trgm/
make && make install

#INSTALA O RECURSO DE IDENTIFICAÇÃO UNIVERSAL
cd $PG_RECURSO
cd uuid-ossp/
make && make install

#INSTALA UTILITARIO DE CRIPTOGRAFIA
cd $PG_RECURSO
cd pgcrypto/
make && make install

#INICIALIZA O DIRETÓRIO DE DADOS
su postgres -c "export LC_CTYPE=en_US.UTF-8 && /opt/PostgreSQL/9.4.26/bin/initdb --data-checksums -D /opt/PostgreSQL/9.4.26/data/"

#COLETA A PORTA PADRÃO DO BANCO DE DADOS
echo -n "Informe a porta padrão do banco de dados: "
read PG_PORT
sed -i -e"s/^#port = 5432.*$/port = $PG_PORT /" $PG_CONFIG

#COLETA O NÚMERO MÁXIMO DE CONEXÕES
echo -n "Informe o número de conexões ($PG_MAX_CONN): "
read PG_MAX_CONN

#MODIFICA AS CONFIGURAÇÕES DO ARQUIVO postgresql.conf
sed -i -e"s/^#listen_addresses =.*$/listen_addresses = '*'/" $PG_CONFIG
sed -i -e"s/^max_connections = 100.*$/max_connections = $PG_MAX_CONN/" $PG_CONFIG
sed -i -e"s/^#standard_conforming_strings = on.*$/standard_conforming_strings = on/" $PG_CONFIG
sed -i -e"s/^#log_destination = 'stderr'.*$/log_destination = 'stderr'/" $PG_CONFIG
sed -i -e"s/^#logging_collector = off.*$/logging_collector = on/" $PG_CONFIG
sed -i -e"s/^#log_directory = 'pg_log'.*$/log_directory = 'pg_log'/" $PG_CONFIG
sed -i -e"s/^#log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'.*$/log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'/" $PG_CONFIG
sed -i -e"s/^#log_line_prefix = ''.*$/log_line_prefix = '%t'/" $PG_CONFIG
sed -i -e"s/^log_timezone = '*'.*$/log_timezone = '-3'/" $PG_CONFIG
sed -i -e"s/^timezone = '*'.*$/timezone = '-3'/" $PG_CONFIG

echo "Informe a senha: "
#DESATIVA A IMPRESSÃO NA CONSOLE PARA NINGUEM VER A SENHA DIGITADA
stty -echo
#COLETA A SENHA DO BANCO DE DADOS
read PG_PASSWORD
#ATIVA NOVAMENTE A IMPRESSÃO DE SAÍDA NA CONSOLE
stty echo
#COLETA OS DADOS DA REDE DO USUÁRIO: 10.1.1.0/12
echo -n "Informe a rede ($PG_ADDRESS): "
read PG_ADDRESS

#INICIALIZA O BANCO DE DADOS
$PG_START start

#AGUARDA O PROCESSO SER INICIALIZADO
sleep 2
STRINGTEST=`ps -ef | grep postgres | awk '{print $2}' | head -1`

while [ "$STRINGTEST" = "" ]
do
echo "processo não encontrado"		
sleep 1
STRINGTEST=`ps -ef | grep postgres | awk '{print $2}' | head -1`
done

#ALTERA AS PERMISSÕES DO USUÁRIO POSTGRES
su -c "$PG_PSQL -U $PG_USER -p $PG_PORT -c \"ALTER USER postgres WITH PASSWORD '$PG_PASSWORD';\"" $PG_USER

#MODIFICA AS CONFIGURAÇÕES DO ARQUIVO pg_hba.conf
# Modificado por Marcelo para usar no Zabbix Proxy
#sed -i "s|local   all             all                                     trust|local   all             all                                     md5|g" $PG_HBA
#sed -i "s|host    all             all             127.0.0.1/32            trust|host    all             all             $PG_ADDRESS            md5|g" $PG_HBA
#sed -i "s|host    all             all             ::1/128                 trust|host    all             all             ::1/128                 md5|g" $PG_HBA


#ABRE A PORTA NO FIREWALL
iptables -A INPUT -i eth0 -p tcp -m tcp --dport $PG_PORT -j ACCEPT

#SALVA O FIREWALL
iptables-save

$PG_START restart

apt install unzip -y 
cd $PG_EXTENSION
wget http://download.systemaonline.com.br/systema/postgresql/external_file.control 
wget http://download.systemaonline.com.br/systema/postgresql/external_file--1.0.zip 
unzip external_file--1.0.zip 
rm external_file--1.0.zip

cd $PG_DOCUMENTOS
mkdir documentos
#mkdir -p administrativo/documento/servico_de_compras/ordem_de_compra/
mkdir -p administrativo/
mkdir -p docusign/certificado/
mkdir -p prontuario_digital/
chown -R postgres:postgres documentos
chown -R postgres:postgres administrativo
chown -R postgres:postgres docusign
chown -R postgres:postgres prontuario_digital

#mkdir -p /opt/PostgreSQL/9.4.26/data/administrativo/
#mkdir -p /opt/PostgreSQL/9.4.26/data/docusign/certificado/
#chown -R postgres:postgres /opt/PostgreSQL/9.4.26/data/administrativo
#chown -R postgres:postgres /opt/PostgreSQL/9.4.26/data/docusign

#EXIBE O STATUS DO PROCESSO
ps aux | grep postgres

lsb_release -a

hostnamectl

cat /etc/issue
