@echo off
REM Define o destino final onde os arquivos serão copiados
set DESTINO="C:\BASE_FORTES_AC_CSV"

REM Função para copiar arquivos caso a pasta esteja acessível
call :copiar "\\10.30.10.20\weknow\FortesDemonstrativos"
call :copiar "\\10.31.10.20\weknow\FortesDemonstrativos"
call :copiar "\\10.32.10.20\weknow\FortesDemonstrativos"
call :copiar "\\10.33.10.20\weknow\FortesDemonstrativos"
call :copiar "\\10.34.10.20\weknow\FortesDemonstrativos"
call :copiar "\\10.35.15.20\weknow\FortesDemonstrativos"
call :copiar "\\10.36.10.20\weknow\FortesDemonstrativos"
call :copiar "\\10.37.10.20\weknow\FortesDemonstrativos"
call :copiar "\\10.38.10.20\weknow\FortesDemonstrativos"
call :copiar "\\10.39.10.20\weknow\FortesDemonstrativos"
call :copiar "\\10.40.10.20\weknow\FortesDemonstrativos"
call :copiar "\\10.41.10.20\weknow\FortesDemonstrativos"
call :copiar "\\10.42.10.20\weknow\FortesDemonstrativos"

REM Mensagem final
echo Todos os arquivos foram copiados para %DESTINO%

timeout /t 5
exit /b

REM Função que valida o acesso à pasta e realiza a cópia
:copiar
if exist "%~1\" (
    echo Pasta %~1 acessivel. Iniciando copia...
    copy "%~1\*" %DESTINO%
) else (
    echo ERRO: Pasta %~1 nao esta acessivel.
)
 