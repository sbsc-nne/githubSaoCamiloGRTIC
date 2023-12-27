param (
    [string]$serialNumber,
    [string]$outputFormat
)

$cert = Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object { $_.SerialNumber -eq $serialNumber }

if ($cert) {
    $expirationDate = $cert.NotAfter
    $currentDate = Get-Date
    $daysRemaining = ($expirationDate - $currentDate).Days

    if ($outputFormat -eq "datetime") {
        # Exibir a data de expiração no formato "DDMMAAAA HH:MM:SS"
        $expirationDateFormatted = $expirationDate.ToString("ddMMyyyy HH:mm:ss")
        Write-Output $expirationDateFormatted
    } elseif ($outputFormat -eq "daysremaining") {
        # Exibir os dias restantes
        Write-Output $daysRemaining
    } else {
        Write-Output "Formato de saída não reconhecido. Use 'datetime' ou 'daysremaining'."
    }
} else {
    Write-Output "Certificate not found"
}
