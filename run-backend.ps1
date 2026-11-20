param([int]$Port = 8080)

$ErrorActionPreference = 'Stop'
if ($Port -lt 1 -or $Port -gt 65535) { throw 'Port must be between 1 and 65535.' }
$previousUser = $env:LIBMAN_DB_USER
$previousPassword = $env:LIBMAN_DB_PASSWORD
$exitCode = 1
Push-Location $PSScriptRoot
try {
    $configPath = $env:LIBMAN_DB_CONFIG
    if (-not $configPath) { $configPath = Join-Path $PSScriptRoot 'config\database.properties' }
    # Reuse an existing external config. Otherwise prompt without writing a password to disk.
    if (-not (Test-Path -LiteralPath $configPath)) {
        if (-not $env:LIBMAN_DB_USER) {
            $dbUser = Read-Host 'MySQL user (Enter = root)'
            $env:LIBMAN_DB_USER = if ([string]::IsNullOrWhiteSpace($dbUser)) { 'root' } else { $dbUser }
        }
        if ($null -eq $env:LIBMAN_DB_PASSWORD) {
            $securePassword = Read-Host 'MySQL password' -AsSecureString
            $env:LIBMAN_DB_PASSWORD = [System.Net.NetworkCredential]::new('', $securePassword).Password
        }
    }
    & mvn compile exec:java "-Dport=$Port"
    $exitCode = $LASTEXITCODE
} finally {
    $env:LIBMAN_DB_USER = $previousUser
    $env:LIBMAN_DB_PASSWORD = $previousPassword
    Pop-Location
}
exit $exitCode
