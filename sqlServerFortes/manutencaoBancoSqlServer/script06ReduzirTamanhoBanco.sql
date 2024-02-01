/*
SQLServer
Data Criação: 01/02/2023
@Marcelo Grando
*/

/*-- Script 06
Executa o SHRIKDATABASE para reduzir o tamanho Banco de Dados. */
USE [SeuBancoDeDados]
GO
DBCC SHRINKDATABASE(N'SeuBancoDeDados')
GO