# Lista de caminhos dos arquivos .exe
$listaDeArquivos = @(
    "\\10.1.0.100\Systemah2005\Modulos\syscad.exe",
    "\\10.1.0.111\Fortes\AC\AC.exe",
    "\\10.1.0.111\Fortes\Ponto\Ponto.exe",
    "\\10.1.0.111\Fortes\AC\Agente\Agente.exe"
    # Adicione mais caminhos conforme necessário
)

# Caminho para o arquivo de texto de saída
$caminhoArquivoSaida = "C:\Users\Administrator\Desktop\output\version_files.txt"

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
