/*
SQLServer
Data Criação: 01/02/2023
@Marcelo Grando
*/

/* Script 13
Verificar a quantidade de registros da tabela AUD = Auditoria.
*/
SELECT 
	count(*) 
FROM 
	AUD
WHERE AUD.DataHora < '2022-12-31'
