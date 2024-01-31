/*
SQLServer
Data Criação: 19/01/2023
@Marcelo Grando
Script para Realizar backup de um Banco de dados
ATENCAO: É necessário alterar o valor dos parâmetros @databaseName e @backupPath 
*/
-- Backup completo do Banco de Dados
DECLARE @databaseName NVARCHAR(128) = 'NomeBancoDeDados'
DECLARE @backupPath NVARCHAR(255) = 'C:\Caminho\arquico\backup.bak'
DECLARE @backupStatement NVARCHAR(MAX)

SET @backupStatement = 
    'BACKUP DATABASE ' + QUOTENAME(@databaseName) + '
    TO DISK = ' + QUOTENAME(@backupPath, '''') + '
    WITH NOFORMAT, INIT, 
    NAME = N''' + @databaseName + '-Full Database Backup'', 
    SKIP, NOREWIND, NOUNLOAD, STATS = 10'

-- Execute the dynamic SQL
EXEC sp_executesql @backupStatement

--  Verifica se o Backup foi bem sucedido
RESTORE VERIFYONLY
FROM DISK = @backupPath
