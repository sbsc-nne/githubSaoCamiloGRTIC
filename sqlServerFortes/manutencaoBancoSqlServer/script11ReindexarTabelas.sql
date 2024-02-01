/*
SQLServer
Data Criação: 01/02/2023
@Marcelo Grando
*/

/* Script 11
Reindexação de Tabelas:
*/
USE SeuBancoDeDados;
DECLARE @TableName NVARCHAR(255);
DECLARE TableCursor CURSOR FOR
SELECT table_name
FROM information_schema.tables
WHERE table_type = 'BASE TABLE';

OPEN TableCursor;
FETCH NEXT FROM TableCursor INTO @TableName;

WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC ('ALTER INDEX ALL ON ' + @TableName + ' REBUILD;');
    FETCH NEXT FROM TableCursor INTO @TableName;
END

CLOSE TableCursor;
DEALLOCATE TableCursor;