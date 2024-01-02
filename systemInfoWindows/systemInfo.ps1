# ShellScript
# Data Criação: 02-01-2024
# @Marcelo Grando
# dir = C:\zabbiz\script\systemInfo.ps1
# Script retornar informacoes personalizadas do SO Windows

param (
    [string]$infoType
)

$osInfo = Get-CimInstance Win32_OperatingSystem
$systemLocale = Get-WinSystemLocale

# Mapeamento de códigos de idioma para descrições
$languageMappings = @{
    "ar-SA" = "Arábico (Arábia Saudita)"
    "en-US" = "Inglês (Estados Unidos)"
    "pt-BR" = "Português (Brasil)"
    # Adicione mais mapeamentos conforme necessário
}

# Obter a descrição do idioma
$languageCode = $systemLocale.Name
$languageDescription = $languageMappings[$languageCode]

if (-not $languageDescription) {
    $languageDescription = "Idioma não mapeado: $languageCode"
}

$version = $osInfo.Version

switch -Wildcard ($version) {
    "6.3*" { $os = "Windows Server 2012 R2" }
    "10.0*" { $os = "Windows Server 2016" }
    "10.0.14393*" { $os = "Windows Server 2016 (versão 1607)" }
    "10.0.17763*" { $os = "Windows Server 2019" }
    "10.0.19042*" { $os = "Windows Server 2022" }
    Default { $os = "Versão não identificada: $version" }
}

# Retornar a informação solicitada com base no parâmetro
switch ($infoType) {
    "NomeSistema" { $result = $osInfo.Caption }
    "Versao" { $result = $os }
    "NumeroCompilacao" { $result = $osInfo.BuildNumber }
    "Arquitetura" { $result = $osInfo.OSArchitecture }
    "Fabricante" { $result = $osInfo.Manufacturer }
    "IdiomaCodigo" { $result = $languageCode }
    "IdiomaDescricao" { $result = $languageDescription }
    Default { $result = "Parâmetro inválido" }
}

$result
