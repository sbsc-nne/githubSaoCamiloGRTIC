#!/PowerShell
# Data Criação: 30  -11-2023
# @Marcelo Grando
# create_structure_version_files.ps1
# Script estruturar a verificação das versões de arquivos EXE (Monitoramento Zabbix)

# Variáveis
#$fullPathFileDefault = 'C:\zabbix_agent2\check_version_files\version_files_teste.ps1'
$directoryDefault = "C:\zabbix_agent2\check_version_files"  #Split-Path $fullPathFileDefault -Parent
$urlFileConfig = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/version_files_exe/version_files.ps1"
$urlFileTaskXML = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/version_files_exe/task_check_version_files.xml"

# Criar um diretório
if (-not (Test-Path -Path $directoryDefault -PathType Container)) {
    New-Item -Path $directoryDefault -ItemType Directory
}

# Nome do arquivo local (extraído do URL) $urlFileConfig
$nameLocalFile = Join-Path $directoryDefault (Split-Path $urlFileConfig -Leaf)

# Baixa o arquivo e salva localmente $urlFileConfig
Invoke-WebRequest -Uri $urlFileConfig -OutFile $nameLocalFile

# Nome do arquivo local (extraído do URL) $urlFileTaskXML
$nameLocalFile = Join-Path $directoryDefault (Split-Path $urlFileTaskXML -Leaf)

# Baixa o arquivo e salva localmente $urlFileTaskXML
Invoke-WebRequest -Uri $urlFileTaskXML -OutFile $nameLocalFile

$pathFullXml = Join-Path -Path $directoryDefault -ChildPath $nameLocalFile

# Caminho para o arquivo XML que contém a definição da tarefa agendada
$pathFullXml = "C:\Caminho\Para\Seu\Arquivo.xml"

# Importa a tarefa agendada a partir do XML
Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-File $pathFullXml") -TaskName "check_version_files_2"