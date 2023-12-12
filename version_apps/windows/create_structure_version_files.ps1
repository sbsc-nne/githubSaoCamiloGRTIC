#!/PowerShell
# Data Criação: 30-11-2023
# @Marcelo Grando
# create_structure_version_files.ps1
# Script estruturar a verificação das versões de arquivos EXE (Monitoramento Zabbix)

# Variáveis
param (
    [string]$ipZabbixProxy
)

# Verifica se a primeira variável foi passada
if (-not $ipZabbixProxy) {
    Write-Host "Informar o IP do Zabbix Proxy via parametro -ipZabbixProxy. O script será encerrado."
    exit
}
$directory1 = "C:\zabbix"
$directory2 = "C:\zabbix\zabbix_agent2.conf.d"
$directory3 = "C:\zabbix\script"
$urlInstallZabbixAgent2Bat = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/zabbix-5.0/windows/InstallZabbixAgent2.bat"
$urlZabbixAgent2Conf = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/zabbix-5.0/windows/zabbix_agent2.conf"
$urlZabbixAgent2Exe = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/zabbix-5.0/windows/zabbix_agent2.exe"
$urlUserParameter = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/version_apps/windows/userparameter_version_file_win.conf"
$urlVersionFileWinPs1 = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/version_apps/windows/version_file_win.ps1"


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

if (-not (Test-Path -Path $directory3 -PathType Container)) {
    New-Item -Path $directory3 -ItemType Directory
    Write-Host "Diretório $directory3 criado com Sucesso!"
} else {
    Write-Host "O diretório $directory3 já existe."
}

# Nome do arquivo local (extraído do URL) $urlInstallZabbixAgent2Bat
$nameLocalFile = Join-Path $directory1 (Split-Path $urlInstallZabbixAgent2Bat -Leaf)
# Baixa o arquivo e salva localmente $urlInstallZabbixAgent2Bat
Invoke-WebRequest -Uri $urlInstallZabbixAgent2Bat -OutFile $nameLocalFile

# Nome do arquivo local (extraído do URL) $urlZabbixAgent2Conf
$nameLocalFile = Join-Path $directory1 (Split-Path $urlZabbixAgent2Conf -Leaf)
# Baixa o arquivo e salva localmente $urlZabbixAgent2Conf
Invoke-WebRequest -Uri $urlZabbixAgent2Conf -OutFile $nameLocalFile
$nameFileZabbixAgentConf = $nameLocalFile 

# Nome do arquivo local (extraído do URL) $urlZabbixAgent2Exe
$nameLocalFile = Join-Path $directory1 (Split-Path $urlZabbixAgent2Exe -Leaf)
# Baixa o arquivo e salva localmente $urlZabbixAgent2Exe
Invoke-WebRequest -Uri $urlZabbixAgent2Exe -OutFile $nameLocalFile

# Nome do arquivo local (extraído do URL) $urlUserParameter
$nameLocalFile = Join-Path $directory2 (Split-Path $urlUserParameter -Leaf)
# Baixa o arquivo e salva localmente $urlUserParameter
Invoke-WebRequest -Uri $urlUserParameter -OutFile $nameLocalFile

# Nome do arquivo local (extraído do URL) $urlVersionFileWinPs1
$nameLocalFile = Join-Path $directory3 (Split-Path $urlVersionFileWinPs1 -Leaf)
# Baixa o arquivo e salva localmente $urlVersionFileWinPs1
Invoke-WebRequest -Uri $urlVersionFileWinPs1 -OutFile $nameLocalFile

# ### Configurar os parametros no arquivo zabbix_agent2.conf
$linha1 = 69  # Server=
$linha2 = 109 # ServerActive=

$conteudoLinha1 = "Server=" + $ipZabbixProxy
$conteudoLinha2 = "ServerActive=" + $ipZabbixProxy

# Lê o conteúdo do arquivo
$linhas = Get-Content -Path $nameFileZabbixAgentConf

# Verifica se o número da linha é válido
if ($linha1 -ge 1 -and $linha1 -le $linhas.Count) {
    # Modifica a linha desejada
    $linhas[$linha1 - 1] = $conteudoLinha1
    # Escreve o conteúdo modificado de volta no arquivo
    $linhas | Set-Content -Path $nameFileZabbixAgentConf
    Write-Host "Linha modificada com sucesso."
} else {
    Write-Host "Número de linha inválido."
}

if ($linha2 -ge 1 -and $linha2 -le $linhas.Count) {
    # Modifica a linha desejada
    $linhas[$linha2 - 1] = $conteudoLinha2
    # Escreve o conteúdo modificado de volta no arquivo
    $linhas | Set-Content -Path $nameFileZabbixAgentConf
    Write-Host "Linha modificada com sucesso."
} else {
    Write-Host "Número de linha inválido."
}

# ####Instalar o servico do Zabbix Agent ####
Write-Host "Instalando o Serviço do Zabbix Agent 2..."
# Nome do serviço
$nomeDoServico = "Zabbix Agent 2"

# Executável do serviço
$caminhoDoExecutavel = "C:\zabbix\zabbix_agent2.exe -i -c C:\zabbix\zabbix_agent2.conf"

# Descrição do serviço (opcional)
$descricaoDoServico = "Zabbix Agent 2"

# Configuração do serviço
$configuracaoDoServico = @{
    DisplayName = $nomeDoServico
    Description = $descricaoDoServico
    BinaryPathName = $caminhoDoExecutavel
}

# Instala o serviço
New-Service @configuracaoDoServico

# Inicia o serviço
Start-Service -Name $nomeDoServico

# Exibir mensagem
Write-Host "Serviço instalado e iniciado com sucesso: $nomeDoServico"