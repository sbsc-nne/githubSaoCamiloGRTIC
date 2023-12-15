# ShellScript
# Data Criação: 12-12-2023
# @Marcelo Grando
# dir = C:\zabbiz\script\version_file_win.ps1
# Script para retornar versão e nome de um arquivo exe.

# ATENÇÃO: Esse script funciona, porém o Zabbix não consegue executar .ps1 via UserParameter.
# por esse motivo esse script foi reescrito em .bat

# Declaração de parâmetros
param (
    [string]$caminhoArquivo,
    [string]$chave
)

# Verifica se a primeira variável foi passada
if (-not $caminhoArquivo) {
    Write-Host "O caminho deve ser passado como parametro -caminhoArquivo. O script será encerrado."
    exit
}
# Verifica se a segunda variável foi passada
if (-not $chave) {
    Write-Host "O item deve ser passado como parametro -chave [version] or [name]. O script será encerrado."
    exit
}
# Retorna a versão do arquivo
if ($chave -eq "version") {
    $versao = (Get-Command $caminhoArquivo).FileVersionInfo.FileVersion
    Write-Host $versao
}
# Retorna nome do arquivo
if ($chave -eq "name") {
    $nome = (Get-Item $caminhoArquivo).Name
    Write-Host $nome
}