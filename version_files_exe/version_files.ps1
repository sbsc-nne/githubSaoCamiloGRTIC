# Lista de caminhos dos arquivos .exe
$listaDeArquivos = @(
    "\\192.168.0.250\SystemaH2005\Modulos\syscad.exe",
    "\\192.168.0.240\c$\Fortes\AC\AC.exe",
    "\\192.168.0.240\c$\Fortes\Ponto\Ponto.exe",
    "\\192.168.0.240\c$\Fortes\AC\Agente\Agente.exe",
    "\\192.168.0.240\c$\WKRadar\Pgms\Radar\WKRadar.exe"
    # Adicione mais caminhos conforme necessário
)

# Caminho para o arquivo de texto de saída
$caminhoArquivoSaida = "\\192.168.0.246\Backup_FortesAC\check_version_files\version_files.log"

# Exclui o arquivo de saída se ele existir
Remove-Item -Path $caminhoArquivoSaida -ErrorAction SilentlyContinue

# Adicionar data e hora no arquivo de saída
$dataHora = Get-Date -Format "dd/MM/yyyy HH:mm"
Add-Content -Path $caminhoArquivoSaida -Value " DataHora: $dataHora"

# Laço FOR para percorrer a lista de arquivos
foreach ($caminhoArquivo in $listaDeArquivos) {
    # Obter informações sobre o arquivo
    $versao = (Get-Command $caminhoArquivo).FileVersionInfo.FileVersion
    $nome = (Get-Item $caminhoArquivo).Name

    # Formatar e escrever os resultados no arquivo de saída
    Add-Content -Path $caminhoArquivoSaida -Value "$nome $versao"
}

Write-Host "Processo concluído. Resultados salvos em $caminhoArquivoSaida"
