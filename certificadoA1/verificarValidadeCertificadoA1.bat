@echo off
REM !/.bat
REM Data Criacao: 26-12-2023
REM @Marcelo Grando
REM Path C:\zabbix\script\verificarValidadeCertificadoA1.bat
REM Script para retornar a data de expiracao do certificado A1.

REM Numero de serie do certificado (substitua pelo numero de serie do seu certificado)
set "serialNumber=%1"

REM Cria um arquivo temporario PowerShell script
echo # PowerShell script > tempScript.ps1
echo $serialNumber = "%serialNumber%" >> tempScript.ps1
echo $cert = Get-ChildItem -Path Cert:\CurrentUser\My ^| Where-Object { $_.SerialNumber -eq $serialNumber } >> tempScript.ps1
echo if ($cert -eq $null) { >> tempScript.ps1
echo     Write-Host "Certificado nao encontrado." >> tempScript.ps1
echo } else { >> tempScript.ps1
echo     $dataValidade = $cert.NotAfter >> tempScript.ps1
echo     $dataAtual = Get-Date >> tempScript.ps1
echo     $dataValidadeFormatada = $dataValidade.ToString("dd/MM/yyyy HH:mm:ss") >> tempScript.ps1
echo     $dataAtualFormatada = $dataAtual.ToString("dd/MM/yyyy HH:mm:ss") >> tempScript.ps1
echo     Write-Host "$dataValidadeFormatada" >> tempScript.ps1
echo } >> tempScript.ps1

REM Executa o script PowerShell
powershell -File .\tempScript.ps1

REM Remove o arquivo temporario
del tempScript.ps1
