/* Script 01
Tamanho das tabelas individualmente */
SELECT t.NAME AS NomeTabela, p.rows AS QuantidadeDeItens, SUM(a.total_pages) * 8 / 1024 AS TamanhoTotalMB, SUM(a.used_pages) * 8 / 1024 AS TamanhoUsadoMB, (SUM(a.total_pages) - SUM(a.used_pages)) * 8 / 1024 AS TamanhoNaoUsadoMB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.NAME NOT LIKE 'dt%'
AND t.is_ms_shipped = 0
AND i.OBJECT_ID > 255
GROUP BY t.Name, p.Rows
ORDER BY TamanhoTotalMB DESC;

/* Script 02
Tamanho total das tabelas */
SELECT  SUM(p.rows) AS QuantidadeDeItens, SUM(a.total_pages) * 8 / 1024 AS TamanhoTotalMB, SUM(a.used_pages) * 8 / 1024 AS TamanhoUsadoMB, (SUM(a.total_pages) - SUM(a.used_pages)) * 8 / 1024 AS TamanhoNaoUsadoMB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.NAME NOT LIKE 'dt%'
AND t.is_ms_shipped = 0
AND i.OBJECT_ID > 255

/* Script 03
Backup do Banco de dados e Validação do Backup */
BACKUP DATABASE [SeuBancoDeDados] TO  DISK = N'C:\Fortes\backup\SeuBancoDeDados.bak' WITH NOFORMAT, INIT,  NAME = N'SeuBancoDeDados-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N'SeuBancoDeDados' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'SeuBancoDeDados' )
if @backupSetId is null begin raiserror(N'Verify failed. Backup information for database ''SeuBancoDeDados'' not found.', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N'C:\Fortes\backup\SeuBancoDeDados.bak' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO

/* Script 04
-- Faça um backup do log do banco de dados. */
BACKUP LOG SeuBancoDeDados TO DISK = 'C:\Fortes\backup\log_backup.bak';

/* Script 05
Use o comando DBCC SHRINKFILE para reduzir o tamanho do arquivo de log.
Usar o nome lógico do arquivo de LOG */
DBCC SHRINKFILE (SeuBancoDeDados_log, 200);

/* OBS.: Após terminar o backup precisa acessar as propriedade do banco e mudar o Recovery Model para Simple.*/

/*-- Script 06
Executa o SHRIKDATABASE para reduzir o tamanho Banco de Dados. */
USE [SeuBancoDeDados]
GO
DBCC SHRINKDATABASE(N'SeuBancoDeDados')
GO

/* Script 07

Orientações disponiveis no site da Fortes para verificação do Banco*/

--Realizar um check do database (verificação de erro no banco)
DBCC CHECKDB ('SeuBancoDeDados')
GO

/* ATENÇÃO - Os comandos abaixo somente devem ser executados caso retorar algum erro no resultado
do script anterior.*/
/*---- INICIO ----*/ 
    --Coloca o database em modo de emergência
    ALTER DATABASE SeuBancoDeDados SET EMERGENCY
    GO
    
    --Alterar o database para SINGLE_USER, ou seja, só um usuário pode estar conectado
    ALTER DATABASE SeuBancoDeDados SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    GO

    --Realizar o comando para reparo do database
    DBCC CHECKDB ('SeuBancoDeDados' , REPAIR_ALLOW_DATA_LOSS) WITH NO_INFOMSGS, ALL_ERRORMSGS
    GO

    DBCC CHECKDB ('SeuBancoDeDados' , REPAIR_REBUILD) WITH NO_INFOMSGS, ALL_ERRORMSGS
    GO

    --Volta a base de dados para múltiplos usuários 
    ALTER DATABASE SeuBancoDeDados SET MULTI_USER
    GO

    --Resetar o status do database 
    EXEC sp_resetstatus 'SeuBancoDeDados'
/*---- FIM ----*/

/* Script 08
--Rodar Script para checar o status do  READ_COMMITTED:
*/
SELECT name, is_read_committed_snapshot_on from sys.databases;

/*Caso o resultado seja 0(zero) - no campo is_read_committed_snapshot_on, rodar os 3 scripts 
abaixo para ligar o parâmetro*/
/*---- INICIO ----*/
    --Linha de Execução 1:
    ALTER DATABASE SeuBancoDeDados SET READ_COMMITTED_SNAPSHOT ON;

    --Linha de Execução 2:
    ALTER DATABASE SeuBancoDeDados SET AllOW_SNAPSHOT_ISOLATION ON;
    
    --Linha de Execução 3:
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
/*---- FIM ----*/

/* Script 09
Verificação dos índices do banco de dados
Objetivo: Conferir e tratar o desgaste dos índices conforme necessidade.
Script de checagem dos índices:
*/
SELECT a.object_id, object_name(a.object_id) AS TableName,
   a.index_id, name AS IndedxName, avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats
   (DB_ID (N'SeuBancoDeDados') -- Colocar o nome do banco. Se não colocar nada ele verifica todos os bancos. 
       , OBJECT_ID(N'') -- se for buscar em uma tabela específica colocar ela entre as aspas
       , NULL
       , NULL
       , NULL) AS a
INNER JOIN sys.indexes AS b
   ON a.object_id = b.object_id
   AND a.index_id = b.index_id
Order by  avg_fragmentation_in_percent desc;
GO

/* Script 10

Quando o resultado aparecer na tela, a última coluna é a porcentagem (%) de fragmentação dos índices. 
A Microsoft orienta que seja, no máximo, 30%. Se passar desse valor, execute o script de reorganização de índices. 
Script de reorganização de índices:
*/

DECLARE @tableName nvarchar(500) 
DECLARE @indexName nvarchar(500) 
DECLARE @percentFragment decimal(11,2) 
DECLARE @page_count int
DECLARE FragmentedTableList cursor for  

SELECT  dbtables.[name] AS 'Table',  dbindexes.[name] AS 'Index', indexstats.avg_fragmentation_in_percent,  indexstats.page_count
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS indexstats 

INNER JOIN sys.tables dbtables
            ON dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas
            ON dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes dbindexes
            ON dbindexes.[object_id] = indexstats.[object_id]   AND indexstats.index_id = dbindexes.index_id  AND dbindexes.[name] IS NOT NULL 

WHERE indexstats.database_id = DB_ID()
            AND indexstats.avg_fragmentation_in_percent > 05
            AND indexstats.page_count  > 10 
ORDER BY indexstats.page_count DESC, indexstats.avg_fragmentation_in_percent DESC 

OPEN FragmentedTableList 
FETCH NEXT FROM FragmentedTableList  
INTO   @tableName, @indexName, @percentFragment, @page_count 

WHILE @@FETCH_STATUS = 0
  BEGIN 
              PRINT 'Processando ' + @indexName + ' na tabela ' + @tableName + ' com ' + CAST(@percentFragment AS NVARCHAR(50)) + '% fragmentado'

   IF(@percentFragment BETWEEN 05 AND 30) 
      BEGIN 

           EXEC( 'ALTER INDEX ' +  @indexName + ' ON ' + @tableName + ' REORGANIZE;')
           PRINT 'Concluindo a reorganização do índice ' + @indexName + ' da tabela ' + @tableName
      END

   ELSE IF (@percentFragment > 30) 
     BEGIN
         EXEC( 'ALTER INDEX ' +  @indexName + ' ON ' + @tableName + ' REBUILD; ')
         PRINT 'Concluindo a recriação do índice ' + @indexName + 'da tabela ' + @tableName
     END

     FETCH NEXT FROM FragmentedTableList
     INTO @tableName, @indexName, @percentFragment,@page_count
  END  

CLOSE FragmentedTableList 
DEALLOCATE FragmentedTableList

/* Script 10
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

/* Script 11
Atualização de Estatísticas:
*/
USE SeuBancoDeDados;
EXEC sp_updatestats;

/* Script 12
Verificar a quantidade de registros da tabela AUD = Auditoria.
*/
SELECT 
	count(*) 
FROM 
	AUD
WHERE AUD.DataHora < '2022-12-31'
/* Script 12
Limpar a tabela de Auditoria MANTER BACKUP DO BANCO PARA CONSULTAS DE LOG DO PASSADO
*/

DELETE FROM AUD WHERE AUD.DataHora < '2022-12-31'
