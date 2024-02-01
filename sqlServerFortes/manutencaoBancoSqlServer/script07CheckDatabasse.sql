/*
SQLServer
Data Criação: 01/02/2023
@Marcelo Grando
*/

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
