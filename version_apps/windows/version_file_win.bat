@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Por favor, forneca o caminho absoluto do arquivo .exe como parametro.
    goto :eof
)

set "arquivo=%~1"

if not exist "%arquivo%" (
    echo O arquivo "%arquivo%" nao foi encontrado.
    goto :eof
)

for /f "delims=" %%v in ('powershell -Command "(Get-Command '%arquivo%').FileVersionInfo.ProductVersion"') do (
    set "versao=%%v"
    echo !versao!
)

endlocal