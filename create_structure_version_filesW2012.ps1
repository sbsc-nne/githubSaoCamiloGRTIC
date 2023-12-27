#!/PowerShell
# Data Criação: 30-11-2023
# @Marcelo Grando
# create_structure_version_filesW2012.ps1
# Script estruturar a verificação das versões de arquivos EXE (Monitoramento Zabbix)

# Variáveis
#param (
#    [string]$ipZabbixProxy
#)
# Solicitar que o usuário informe um valor
$ipZabbixProxy = Read-Host "Informe o IP do Zabbix Proxy:"
# Verifica se a primeira variável foi passada
if (-not $ipZabbixProxy) {
    Write-Host "IP do servidor do Zabbix Proxy não foi informado. O script será encerrado."
    exit
}
$ipSystemaH = Read-Host "Informe o IP do Servidor do SystemaH2005:"
if (-not $ipSystemaH) {
    Write-Host "IP do servidor do SystemaH não foi informado. O script será encerrado."
    exit
}

$directory1 = "C:\zabbix"
$directory2 = "C:\zabbix\zabbix_agent2.conf.d"
$directory3 = "C:\zabbix\script"
$urlInstallZabbixAgent2Bat  = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/zabbix-5.0/windows/InstallZabbixAgent2.bat"
$urlZabbixAgent2Conf        = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/zabbix-5.0/windows/zabbix_agent2.conf"
$urlZabbixAgent2Exe         = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/zabbix-5.0/windows/zabbix_agent2.exe"
$urlZabbixGetExe            = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/zabbix-5.0/windows/zabbix_get.exe"
$urlZabbixSerderExe         = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/zabbix-5.0/windows/zabbix_sender.exe"
$urlUserParameterFortes     = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/version_apps/windows/userparameter_version_file_fortes.conf"
$urlUserParameterSystema    = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/version_apps/windows/userparameter_version_file_systemah.conf"
$urlUserParameterWK         = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/version_apps/windows/userparameter_version_file_wksistemas.conf"
$urlVersionFileWinBat       = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/version_apps/windows/version_file_win.bat"
# Certificado A1
$urlCertificateValidity = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/certificadoA1/certificateValidity.ps1"
$urlUserparameterCertificateValidity = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/certificadoA1/userparameter_certificateValidity.conf"


# Verifica se o servico do Zabbix Agent 2 está instalado. 
# Se estiver, ele para o servico, exclui o servico, 
# remove a chave do registro de eventos e exclui a pasta C:\zabbix

# Nome do serviço do Zabbix Agent 2
$nomeServico = "Zabbix Agent 2"

# Verifica se o serviço está instalado
if (Get-Service -Name $nomeServico -ErrorAction SilentlyContinue) {
    # Para o serviço
    Write-Host "# Para o servico"
    Stop-Service -Name $nomeServico -Force
    Start-Sleep -s 2

    # Remove o serviço
    Write-Host "# Remove o servico"
    sc.exe delete $nomeServico
    Start-Sleep -s 2

    # Remove a chave do registro de eventos
    Write-Host "# Remove a chave do registro de eventos"
    Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application\Zabbix Agent 2" -Force -Recurse
    Start-Sleep -s 2

    # Remove a pasta C:\zabbix
    Write-Host "# Remove a pasta C:\zabbix"
    Remove-Item -Path "C:\zabbix" -Force -Recurse

    Write-Host "Servico do Zabbix Agent 2 removido com sucesso."
} else {
    Write-Host "O servico do Zabbix Agent 2 nao esta instalado."
}

# Criar Diretorios
if (-not (Test-Path -Path $directory1 -PathType Container)) {
    New-Item -Path $directory1 -ItemType Directory
    Write-Host "Diretorio $directory1 criado com Sucesso!"
} else {
    Write-Host "O diretorio $directory1 já existe."
}

if (-not (Test-Path -Path $directory2 -PathType Container)) {
    New-Item -Path $directory2 -ItemType Directory
    Write-Host "Diretorio $directory2 criado com Sucesso!"
} else {
    Write-Host "O Diretorio $directory2 já existe."
}

if (-not (Test-Path -Path $directory3 -PathType Container)) {
    New-Item -Path $directory3 -ItemType Directory
    Write-Host "Diretorio $directory3 criado com Sucesso!"
} else {
    Write-Host "O Diretorio $directory3 já existe."
}

# Nome do arquivo local (extraído do URL) $urlInstallZabbixAgent2Bat
$nameLocalFile = Join-Path $directory1 (Split-Path $urlInstallZabbixAgent2Bat -Leaf)
# Baixa o arquivo e salva localmente $urlInstallZabbixAgent2Bat
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-RestMethod -Uri $urlInstallZabbixAgent2Bat -OutFile $nameLocalFile -SkipCertificateCheck
$nameFileInstallZabbixAgent2Bat = $nameLocalFile

# Nome do arquivo local (extraído do URL) $urlZabbixAgent2Conf
$nameLocalFile = Join-Path $directory1 (Split-Path $urlZabbixAgent2Conf -Leaf)
# Baixa o arquivo e salva localmente $urlZabbixAgent2Conf
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-RestMethod -Uri $urlZabbixAgent2Conf -OutFile $nameLocalFile -SkipCertificateCheck
$nameFileZabbixAgentConf = $nameLocalFile 

# Nome do arquivo local (extraído do URL) $urlZabbixAgent2Exe
$nameLocalFile = Join-Path $directory1 (Split-Path $urlZabbixAgent2Exe -Leaf)
# Baixa o arquivo e salva localmente $urlZabbixAgent2Exe
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-RestMethod -Uri $urlZabbixAgent2Exe -OutFile $nameLocalFile -SkipCertificateCheck

# Nome do arquivo local (extraído do URL) $urlZabbixGetExe
$nameLocalFile = Join-Path $directory1 (Split-Path $urlZabbixGetExe -Leaf)
# Baixa o arquivo e salva localmente $urlZabbixGetExe
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-RestMethod -Uri $urlZabbixGetExe -OutFile $nameLocalFile -SkipCertificateCheck

# Nome do arquivo local (extraído do URL) $urlZabbixSerderExe
$nameLocalFile = Join-Path $directory1 (Split-Path $urlZabbixSerderExe -Leaf)
# Baixa o arquivo e salva localmente $urlZabbixSerderExe
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-RestMethod -Uri $urlZabbixSerderExe -OutFile $nameLocalFile -SkipCertificateCheck


# Nome do arquivo local (extraído do URL) $urlUserParameterFortes
$nameLocalFile = Join-Path $directory2 (Split-Path $urlUserParameterFortes -Leaf)
# Baixa o arquivo e salva localmente $urlUserParameterFortes
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-RestMethod -Uri $urlUserParameterFortes -OutFile $nameLocalFile -SkipCertificateCheck

# Nome do arquivo local (extraído do URL) $urlUserParameterSystema
$nameLocalFile = Join-Path $directory2 (Split-Path $urlUserParameterSystema -Leaf)
# Baixa o arquivo e salva localmente $urlUserParameterSystema
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-RestMethod -Uri $urlUserParameterSystema -OutFile $nameLocalFile -SkipCertificateCheck
$nameUserParameterSystema = $nameLocalFile

# Nome do arquivo local (extraído do URL) $urlUserParameterWK
$nameLocalFile = Join-Path $directory2 (Split-Path $urlUserParameterWK -Leaf)
# Baixa o arquivo e salva localmente $urlUserParameterWK
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-RestMethod -Uri $urlUserParameterWK -OutFile $nameLocalFile -SkipCertificateCheck

# Nome do arquivo local (extraído do URL) $urlVersionFileWinBat
$nameLocalFile = Join-Path $directory3 (Split-Path $urlVersionFileWinBat -Leaf)
# Baixa o arquivo e salva localmente $urlVersionFileWinBat
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-RestMethod -Uri $urlVersionFileWinBat -OutFile $nameLocalFile -SkipCertificateCheck

# Nome do arquivo local (extraído do URL) $urlCertificateValidity
$nameLocalFile = Join-Path $directory3 (Split-Path $urlCertificateValidity -Leaf)
# Baixa o arquivo e salva localmente $urlCertificateValidity
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-RestMethod -Uri $urlCertificateValidity -OutFile $nameLocalFile -SkipCertificateCheck

# Nome do arquivo local (extraído do URL) $urlUserparameterCertificateValidity
$nameLocalFile = Join-Path $directory2 (Split-Path $urlUserparameterCertificateValidity -Leaf)
# Baixa o arquivo e salva localmente $urlUserparameterCertificateValidity
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-RestMethod -Uri $urlUserparameterCertificateValidity -OutFile $nameLocalFile -SkipCertificateCheck

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
    Write-Host "Arquivo $nameFileZabbixAgentConf modificado com sucesso."
} else {
    Write-Host "Numero de linha invalido."
}

if ($linha2 -ge 1 -and $linha2 -le $linhas.Count) {
    # Modifica a linha desejada
    $linhas[$linha2 - 1] = $conteudoLinha2
    # Escreve o conteúdo modificado de volta no arquivo
    $linhas | Set-Content -Path $nameFileZabbixAgentConf
    Write-Host "Arquivo $nameFileZabbixAgentConf modificado com sucesso."
} else {
    Write-Host "Numero de linha invalido."
}

# Incluir a chave no UserParameter para ver versão do SystemaH2005
$caminhoExeSystemaH = "\\$ipSystemaH\SystemaH2005\modulos\syscad.exe"
$textoParaAdicionar = @("","UserParameter=version_systemah, C:\zabbix\script\version_file_win.bat $($caminhoExeSystemaH)")

# Adiciona o texto ao final do arquivo
Add-Content -Path $nameUserParameterSystema -Value $textoParaAdicionar

# ####Instalar o servico do Zabbix Agent através do arquivo .bat ####
Write-Host "Instalando o Zabbix Agent 2 com servico..."
# Executar o arquivo .bat
Start-Process -FilePath $nameFileInstallZabbixAgent2Bat -Wait
Write-Host "Instalacao do Zabbix Agent 2 concluida."

Start-Sleep -s 2

# Abre as portas de entrada e saída no Firewall do Windows
$ports = @(10050)

# Itera sobre as portas e adiciona exceções no Firewall
foreach ($port in $ports) {
    # Regra de entrada
    New-NetFirewallRule -DisplayName "Zabbix Inbound $port" -Direction Inbound -LocalPort $port -Protocol TCP -Action Allow

    # Regra de saída
    New-NetFirewallRule -DisplayName "Zabbix Outbound $port" -Direction Outbound -LocalPort $port -Protocol TCP -Action Allow
}

Write-Host "Portas $ports liberadas no Firewall do Windows."