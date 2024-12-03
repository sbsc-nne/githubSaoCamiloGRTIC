# Caminho do arquivo hosts
$hostsFile = "C:\Windows\System32\drivers\etc\hosts"

# Entradas a serem adicionadas
$entries = @(
    "10.30.10.22   weknow.saocamiloananindeua.local"
    "10.31.10.22   weknow.saocamilobalsas.local"
    "10.32.10.22   weknow.saocamilocrateus.local"
    "10.33.10.22   weknow.saocamilocrateus-upa.local"
    "10.34.10.22   weknow.saocamilocrato.local"
    "10.35.15.22   weknow.saocamiloitapipoca.local"
    "10.36.10.22   weknow.saocamilolimoeirodonorte.local"
    "10.37.10.22   weknow.saocamilopedroii.local"
    "10.38.10.22   weknow.saocamilosantarem.local"
    "10.39.10.22   weknow.saocamilosaogoncalo.local"
    "10.40.10.22   weknow.saocamilotaua.local"
    "10.41.10.22   weknow.saocamilotaua-upa.local"
    "10.42.10.22   weknow.saocamilotiangua.local"
)

# Ler o arquivo hosts
$hostsContent = Get-Content $hostsFile -ErrorAction Stop

# Adicionar entradas se não existirem
foreach ($entry in $entries) {
    if (-not ($hostsContent -contains $entry)) {
        Add-Content -Path $hostsFile -Value $entry
        Write-Host "Adicionado: $entry"
		Start-Sleep -Seconds 1  # Pausa de 1 segundo
    } else {
        Write-Host "Entrada já existe: $entry"
    }
}
