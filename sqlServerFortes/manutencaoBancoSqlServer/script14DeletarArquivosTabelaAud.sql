/*
SQLServer
Data Criação: 01/02/2023
@Marcelo Grando
*/

/* Script 14
Limpar a tabela de Auditoria MANTER BACKUP DO BANCO PARA CONSULTAS DE LOG DO PASSADO
*/

DELETE FROM AUD WHERE AUD.DataHora < '2022-12-31'
