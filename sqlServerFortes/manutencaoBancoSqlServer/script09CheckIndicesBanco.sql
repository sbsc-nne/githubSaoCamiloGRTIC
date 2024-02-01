/*
SQLServer
Data Criação: 01/02/2023
@Marcelo Grando
*/

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
