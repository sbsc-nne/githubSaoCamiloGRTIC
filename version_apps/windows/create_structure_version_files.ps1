#!/PowerShell
# Data Criação: 30-11-2023
# @Marcelo Grando
# create_structure_version_files.ps1
# Script estruturar a verificação das versões de arquivos EXE (Monitoramento Zabbix)

# Variáveis

$directory1 = "C:\zabbix\zabbix_agent2.conf.d"
$directory2 = "C:\zabbix\script"
$urlUserParameter = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/version_files_exe/version_files.ps1"
$urlVersionFileWinPs1 = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/version_files_exe/task_check_version_files.xml"

# Criar diretórios
if (-not (Test-Path -Path $directory1 -PathType Container)) {
    New-Item -Path $directory1 -ItemType Directory
    Write-Host "Diretório $directory1 criado com Sucesso!"
} else {
    Write-Host "O diretório $directory1 já existe."
}

if (-not (Test-Path -Path $directory2 -PathType Container)) {
    New-Item -Path $directory2 -ItemType Directory
    Write-Host "Diretório $directory2 criado com Sucesso!"
} else {
    Write-Host "O diretório $directory2 já existe."
}


# Nome do arquivo local (extraído do URL) $urlFileConfig
$nameLocalFile = Join-Path $directoryDefault (Split-Path $urlFileConfig -Leaf)

# Baixa o arquivo e salva localmente $urlFileConfig
Invoke-WebRequest -Uri $urlFileConfig -OutFile $nameLocalFile

# Nome do arquivo local (extraído do URL) $urlFileTaskXML
$nameLocalFile = Join-Path $directoryDefault (Split-Path $urlFileTaskXML -Leaf)

# Baixa o arquivo e salva localmente $urlFileTaskXML
Invoke-WebRequest -Uri $urlFileTaskXML -OutFile $nameLocalFile

# Caminho para o arquivo XML que contém a definição da tarefa agendada
$pathFullXml = Join-Path -Path $directoryDefault -ChildPath $nameLocalFile

# 

$nameFoldeShedule = "SBSC-SUPERNNE"

# Importa a tarefa agendada a partir do XML

####### CORRIGIR ESSA LINHA AQUI #######
Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-File $pathFullXml") -TaskPath $nameFoldeShedule -TaskName "check_version_files"