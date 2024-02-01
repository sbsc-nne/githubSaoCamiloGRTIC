/*
SQLServer
Data Criação: 01/02/2023
@Marcelo Grando
*/

/* Script 05
Use o comando DBCC SHRINKFILE para reduzir o tamanho do arquivo de log.
Usar o nome lógico do arquivo de LOG */
DBCC SHRINKFILE (SeuBancoDeDados_log, 200);

/* OBS.: Após terminar o backup precisa acessar as propriedade do banco e mudar o Recovery Model para Simple.*/
