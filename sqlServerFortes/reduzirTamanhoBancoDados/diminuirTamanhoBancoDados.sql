/*
SQLServer
Data Criação: 19/01/2023
@Marcelo Grando
Script para Realizar backup do arquivo de LOG, SHRINKFILE do arquivo e SET RECOVERY SIMPLE
ATENCAO: É necessário alterar o valor dos parâmetros:
@DatabaseName, @BackupFilePath e @LogicalLogFileName
*/
/* Executa o SHRIKDATABASE para reduzir o tamanho Banco de Dados. */
USE [Ponto]
GO
DBCC SHRINKDATABASE(N'Ponto')
GO
