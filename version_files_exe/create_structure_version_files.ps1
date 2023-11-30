#!/PowerShell
# Data Criação: 30  -11-2023
# @Marcelo Grando
# create_structure_version_files.ps1
# Script estruturar a verificação das versões de arquivos EXE (Monitoramento Zabbix)

# Variáveis
$fullPathFileDefault = 'C:\zabbix_agent2\check_version_files\version_files_teste.ps1'
$directoryDefault = Split-Path $fullPathFileDefault -Parent
$urlFileConfig = ""

# Criar um diretório
if (-not (Test-Path -Path $directoryDefault -PathType Container)) {
    New-Item -Path $directoryDefault -ItemType Directory
}
