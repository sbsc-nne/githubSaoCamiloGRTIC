DECLARE @NomeBancoDeDados NVARCHAR(255);
SET @NomeBancoDeDados = 'NomeDoBancoDeDados'; -- Substitua pelo nome do seu banco de dados

DECLARE @TableName NVARCHAR(255);
DECLARE @SQL NVARCHAR(MAX);

-- Troca para o banco de dados desejado
EXEC('USE ' + @NomeBancoDeDados);

DECLARE TableCursor CURSOR FOR
SELECT table_name
FROM information_schema.tables
WHERE table_type = 'BASE TABLE';

OPEN TableCursor;
FETCH NEXT FROM TableCursor INTO @TableName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = 'ALTER INDEX ALL ON ' + @TableName + ' REBUILD;';
    EXEC (@SQL);
    FETCH NEXT FROM TableCursor INTO @TableName;
END

CLOSE TableCursor;
DEALLOCATE TableCursor;

-- Atualiza as estatísticas do banco de dados
EXEC sp_updatestats;
