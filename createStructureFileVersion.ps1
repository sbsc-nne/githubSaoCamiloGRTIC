#!/PowerShell
# Data Criação: 30-11-2023
# @Marcelo Grando
# create_structure_version_files.ps1
# Script Instalar Zabbix Agent 2, criar estrutura para verificação das 
#   versões de arquivos EXE e para Verificar a data de validade do certificado A1


# Solicitar que o usuário informe um valor
$ipZabbixProxy = Read-Host "Informe o IP do Zabbix Proxy:"
# Verifica se a variável foi informada
if (-not $ipZabbixProxy) {
    Write-Host "IP do servidor do Zabbix Proxy não foi informado. O script será encerrado."
    exit
}

$ipSystemaH = Read-Host "Informe o IP do Servidor do SystemaH2005:"
# Verifica se a variável foi informada
if (-not $ipSystemaH) {
    Write-Host "IP do servidor do SystemaH não foi informado. O script será encerrado."
    exit
}

$folderSystemaInput = Read-Host "Digite o nome da pasta do SystemaH(Deixar em branco se a pasta for SystemaH2005)"
if ($folderSystemaInput -eq "") {
    $folderSystema = "SystemaH2005"
} else {
    $folderSystema = $folderSystemaInput
}

$directory1 = "C:\zabbix"
$directory2 = "C:\zabbix\zabbix_agent2.conf.d"
$directory3 = "C:\zabbix\script"
# Urls Zabbix Agent 2
$urlInstallZabbixAgent2Bat  = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/zabbix-5.0/windows/InstallZabbixAgent2.bat"
$urlZabbixAgent2Conf        = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/zabbix-5.0/windows/zabbix_agent2.conf"
$urlZabbixAgent2Exe         = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/zabbix-5.0/windows/zabbix_agent2.exe"
$urlZabbixGetExe            = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/zabbix-5.0/windows/zabbix_get.exe"
$urlZabbixSerderExe         = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/zabbix-5.0/windows/zabbix_sender.exe"

# Urls UserParameter FilesVersion
$urlUserParameterFortes     = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/version_apps/windows/userparameterFileVersionFortes.conf"
$urlUserParameterSystema    = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/version_apps/windows/userparameterFileVersionSystemah.conf"
$urlUserParameterWK         = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/version_apps/windows/userparameterFileVersionWksistemas.conf"

# Urls Script FilesVersion
$urlFileVersionWin       = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/version_apps/windows/fileVersionWin.ps1"

# Certificado A1
$urlCertificateValidity = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/certificadoA1/certificateValidity.ps1"
$urlUserparameterCertificateValidity = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/certificadoA1/userparameterCertificateValidity.conf"

# Certificado A1
$urlSystemInfo = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/systemInfoWindows/systemInfo.ps1"
$userparameterSystemInfo = "https://github.com/mgran2003/GITHUB-SAOCAMILO-GRTIC/raw/main/systemInfoWindows/userparameterSystemInfo.conf"

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
Invoke-WebRequest -Uri $urlInstallZabbixAgent2Bat -OutFile $nameLocalFile
$nameFileInstallZabbixAgent2Bat = $nameLocalFile

# Nome do arquivo local (extraído do URL) $urlZabbixAgent2Conf
$nameLocalFile = Join-Path $directory1 (Split-Path $urlZabbixAgent2Conf -Leaf)
# Baixa o arquivo e salva localmente $urlZabbixAgent2Conf
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-WebRequest -Uri $urlZabbixAgent2Conf -OutFile $nameLocalFile
$nameFileZabbixAgentConf = $nameLocalFile 

# Nome do arquivo local (extraído do URL) $urlZabbixAgent2Exe
$nameLocalFile = Join-Path $directory1 (Split-Path $urlZabbixAgent2Exe -Leaf)
# Baixa o arquivo e salva localmente $urlZabbixAgent2Exe
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-WebRequest -Uri $urlZabbixAgent2Exe -OutFile $nameLocalFile

# Nome do arquivo local (extraído do URL) $urlZabbixGetExe
$nameLocalFile = Join-Path $directory1 (Split-Path $urlZabbixGetExe -Leaf)
# Baixa o arquivo e salva localmente $urlZabbixGetExe
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-WebRequest -Uri $urlZabbixGetExe -OutFile $nameLocalFile

# Nome do arquivo local (extraído do URL) $urlZabbixSerderExe
$nameLocalFile = Join-Path $directory1 (Split-Path $urlZabbixSerderExe -Leaf)
# Baixa o arquivo e salva localmente $urlZabbixSerderExe
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-WebRequest -Uri $urlZabbixSerderExe -OutFile $nameLocalFile


# Nome do arquivo local (extraído do URL) $urlUserParameterFortes
$nameLocalFile = Join-Path $directory2 (Split-Path $urlUserParameterFortes -Leaf)
# Baixa o arquivo e salva localmente $urlUserParameterFortes
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-WebRequest -Uri $urlUserParameterFortes -OutFile $nameLocalFile

# Nome do arquivo local (extraído do URL) $urlUserParameterSystema
$nameLocalFile = Join-Path $directory2 (Split-Path $urlUserParameterSystema -Leaf)
# Baixa o arquivo e salva localmente $urlUserParameterSystema
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-WebRequest -Uri $urlUserParameterSystema -OutFile $nameLocalFile
$nameUserParameterSystema = $nameLocalFile

# Nome do arquivo local (extraído do URL) $urlUserParameterWK
$nameLocalFile = Join-Path $directory2 (Split-Path $urlUserParameterWK -Leaf)
# Baixa o arquivo e salva localmente $urlUserParameterWK
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-WebRequest -Uri $urlUserParameterWK -OutFile $nameLocalFile

# Nome do arquivo local (extraído do URL) $urlFileVersionWin
$nameLocalFile = Join-Path $directory3 (Split-Path $urlFileVersionWin -Leaf)
# Baixa o arquivo e salva localmente $urlFileVersionWin
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-WebRequest -Uri $urlFileVersionWin -OutFile $nameLocalFile

# Nome do arquivo local (extraído do URL) $urlCertificateValidity
$nameLocalFile = Join-Path $directory3 (Split-Path $urlCertificateValidity -Leaf)
# Baixa o arquivo e salva localmente $urlCertificateValidity
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-WebRequest -Uri $urlCertificateValidity -OutFile $nameLocalFile

# Nome do arquivo local (extraído do URL) $urlUserparameterCertificateValidity
$nameLocalFile = Join-Path $directory2 (Split-Path $urlUserparameterCertificateValidity -Leaf)
# Baixa o arquivo e salva localmente $urlUserparameterCertificateValidity
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-WebRequest -Uri $urlUserparameterCertificateValidity -OutFile $nameLocalFile

# Nome do arquivo local (extraído do URL) $urlSystemInfo
$nameLocalFile = Join-Path $directory3 (Split-Path $urlSystemInfo -Leaf)
# Baixa o arquivo e salva localmente $urlSystemInfo
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-WebRequest -Uri $urlSystemInfo -OutFile $nameLocalFile

# Nome do arquivo local (extraído do URL) $userparameterSystemInfo
$nameLocalFile = Join-Path $directory2 (Split-Path $userparameterSystemInfo -Leaf)
# Baixa o arquivo e salva localmente $userparameterSystemInfo
Write-Host "Iniciando download do arquivo: $nameLocalFile"
Invoke-WebRequest -Uri $userparameterSystemInfo -OutFile $nameLocalFile

Start-Sleep -s 2

# Abre as portas de entrada e saída no Firewall do Windows

# Solicitação da porta ao usuário
$portInput = Read-Host "Digite a porta desejada (deixe em branco para usar a porta padrão 10050)"
if ($portInput -eq "") {
    $port = 10050
} else {
    $port = [int]$portInput
}

# Abre as portas de entrada e saída no Firewall do Windows
$ports = @($port)

# Itera sobre as portas e adiciona exceções no Firewall
foreach ($port in $ports) {
    # Regra de entrada
    New-NetFirewallRule -DisplayName "Zabbix Inbound $port" -Direction Inbound -LocalPort $port -Protocol TCP -Action Allow

    # Regra de saída
    New-NetFirewallRule -DisplayName "Zabbix Outbound $port" -Direction Outbound -LocalPort $port -Protocol TCP -Action Allow
}

Write-Host "Portas $ports liberadas no Firewall do Windows."

# ### Configurar os parametros no arquivo zabbix_agent2.conf
$linha1 = 69  # Server=
$linha2 = 77  # ListenPort=10050
$linha3 = 109 # ServerActive=


$conteudoLinha1 = "Server=" + $ipZabbixProxy
$conteudoLinha2 = "ListenPort=" + $ports
$conteudoLinha3 = "ServerActive=" + $ipZabbixProxy

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

if ($linha3 -ge 1 -and $linha3 -le $linhas.Count) {
    # Modifica a linha desejada
    $linhas[$linha3 - 1] = $conteudoLinha3
    # Escreve o conteúdo modificado de volta no arquivo
    $linhas | Set-Content -Path $nameFileZabbixAgentConf
    Write-Host "Arquivo $nameFileZabbixAgentConf modificado com sucesso."
} else {
    Write-Host "Numero de linha invalido."
}

# Incluir a chave no UserParameter para ver versão do SystemaH2005
$caminhoExeSystemaH = "\\$ipSystemaH\$folderSystema\modulos\syscad.exe"
$textoParaAdicionar = @("","UserParameter=version_systemah, powershell -ExecutionPolicy Bypass -File ""C:\zabbix\script\fileVersionWin.ps1"" $($caminhoExeSystemaH)")

# Adiciona o texto ao final do arquivo
Add-Content -Path $nameUserParameterSystema -Value $textoParaAdicionar

# ####Instalar o servico do Zabbix Agent através do arquivo .bat ####
Write-Host "Instalando o Zabbix Agent 2 com servico..."
# Executar o arquivo .bat
Start-Process -FilePath $nameFileInstallZabbixAgent2Bat -Wait
Write-Host "Instalacao do Zabbix Agent 2 concluida."

Start-Sleep -s 2

Start-Process services.msc
