/*
SQLServer
Data Criação: 01/02/2023
@Marcelo Grando
*/

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
