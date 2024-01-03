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
    "en-US" = "Ingles (Estados Unidos)"
    "pt-BR" = "Portugues (Brasil)"
    # Adicione mais mapeamentos conforme necessário
}

# Obter a descrição do idioma
$languageCode = $systemLocale.Name
$languageDescription = $languageMappings[$languageCode]

if (-not $languageDescription) {
    $languageDescription = "Idioma nao mapeado: $languageCode"
}

$version = $osInfo.Version

switch -Wildcard ($version) {
    "6.3*" { $os = "Windows Server 2012 R2" }
    "10.0*" { $os = "Windows Server 2016" }
    "10.0.14393*" { $os = "Windows Server 2016 (versão 1607)" }
    "10.0.17763*" { $os = "Windows Server 2019" }
    "10.0.19042*" { $os = "Windows Server 2022" }
    Default { $os = "Versao nao identificada: $version" }
}

# Retornar a informação solicitada com base no parametro
switch ($infoType) {
    "name_system" { $result = $osInfo.Caption }
    "version_system" { $result = $os }
    "compilation_number" { $result = $osInfo.BuildNumber }
    "architecture" { $result = $osInfo.OSArchitecture }
    "manufacturer" { $result = $osInfo.Manufacturer }
    "language_code" { $result = $languageCode }
    "language_description" { $result = $languageDescription }
    Default { $result = "Parametro invalido" }
}

$result
