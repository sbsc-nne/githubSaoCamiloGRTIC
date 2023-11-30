#!/PowerShell
# Data Criação: 30  -11-2023
# @Marcelo Grando
# create_structure_version_files.ps1
# Script estruturar a verificação das versões de arquivos EXE (Monitoramento Zabbix)

# Variáveis
#$fullPathFileDefault = 'C:\zabbix_agent2\check_version_files\version_files_teste.ps1'
$directoryDefault = "C:\zabbix_agent2\check_version_files"  #Split-Path $fullPathFileDefault -Parent
$urlFileConfig = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/version_files_exe/version_files.ps1"

# Criar um diretório
if (-not (Test-Path -Path $directoryDefault -PathType Container)) {
    New-Item -Path $directoryDefault -ItemType Directory
}

# Nome do arquivo local (extraído do URL)
$nameLocalFile = Join-Path $directoryDefault (Split-Path $urlFileConfig -Leaf)

# Baixa o arquivo e salva localmente
Invoke-WebRequest -Uri $urlFileConfig -OutFile $nameLocalFile