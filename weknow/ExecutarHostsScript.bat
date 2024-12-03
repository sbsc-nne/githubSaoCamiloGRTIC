@echo off
:: Verifica se o script está sendo executado como administrador
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Este script deve ser executado como administrador.
    pause
    exit /b
)

:: Caminho do script PowerShell
set scriptPath=%~dp0script_hosts_super.ps1

:: Executa o script PowerShell
powershell -ExecutionPolicy Bypass -File "%scriptPath%"
pause
