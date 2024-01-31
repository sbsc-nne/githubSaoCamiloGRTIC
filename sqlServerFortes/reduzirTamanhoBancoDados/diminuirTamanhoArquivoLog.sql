/*
SQLServer
Data Criação: 19/01/2023
@Marcelo Grando
Script para Realizar backup do arquivo de LOG, SHRINKFILE do arquivo e SET RECOVERY SIMPLE
ATENCAO: É necessário alterar o valor dos parâmetros:
@DatabaseName, @BackupFilePath e @LogicalLogFileName
*/
DECLARE @DatabaseName NVARCHAR(MAX) = 'Ponto';
DECLARE @BackupFilePath NVARCHAR(MAX) = 'C:\Fortes\DATA\bkp\Ponto_1.ldf';
DECLARE @LogicalLogFileName NVARCHAR(MAX) = 'Ponto2_Log';

DECLARE @BackupCommand NVARCHAR(MAX);

SET @BackupCommand = 'BACKUP LOG [' + @DatabaseName + '] TO DISK = ''' + @BackupFilePath + ''';';

-- Execute the backup command
EXEC sp_executesql @BackupCommand;

DECLARE @ShrinkCommand NVARCHAR(MAX);

SET @ShrinkCommand = 'DBCC SHRINKFILE(N''' + @LogicalLogFileName + ''', 200);';

-- Execute the shrink command
EXEC sp_executesql @ShrinkCommand;

/* Alterar o modo de recuperação para SIMPLE. */
DECLARE @AlterCommand NVARCHAR(MAX);

SET @AlterCommand = 'ALTER DATABASE [' + @DatabaseName + '] SET RECOVERY SIMPLE;';

-- Execute the ALTER command
EXEC sp_executesql @AlterCommand;
