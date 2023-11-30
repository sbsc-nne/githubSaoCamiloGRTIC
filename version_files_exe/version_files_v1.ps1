# Caminho do arquivo executável
$filePath = "C:\Program Files\weKnow\Client\wknw_client.exe"

\\10.1.0.111\Fortes\AC\AC.exe

# Verificar se o arquivo existe
if (Test-Path $filePath -PathType Leaf) {
    # Obter a versão do arquivo
    $fileVersion = (Get-Command $filePath).FileVersionInfo.FileVersion

    # Obter informações sobre o arquivo
    $infoFiles = Get-Item $filePath
    
    # Obter o nome do arquivo
    $fileName = $infoFiles.Name    
    
    # Caminho para o arquivo de texto de saída
    $outputFilePath = "C:\Users\administrador\Desktop\output\Resultado.txt"

    $result = "$fileName:`n $fileVersion"
    
    # Salvar a versão em um arquivo de texto
    $result | Out-File -FilePath $outputFilePath

    Write-Host "A versão do arquivo foi salva em $outputFilePath"
} else {
    Write-Host "O arquivo não foi encontrado: $filePath"
}
