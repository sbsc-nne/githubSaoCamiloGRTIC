/*
SQLServer
Data Criação: 01/02/2023
@Marcelo Grando
*/

/* Script 03
Backup do Banco de dados e Validação do Backup */
BACKUP DATABASE [SeuBancoDeDados] TO  DISK = N'C:\Fortes\backup\SeuBancoDeDados.bak' WITH NOFORMAT, INIT,  NAME = N'SeuBancoDeDados-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N'SeuBancoDeDados' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'SeuBancoDeDados' )
if @backupSetId is null begin raiserror(N'Verify failed. Backup information for database ''SeuBancoDeDados'' not found.', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N'C:\Fortes\backup\SeuBancoDeDados.bak' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO
