param(
    [Parameter(Mandatory = $true)]
    [string]$NetBeansPath
)

$ErrorActionPreference = 'Stop'
$projectPath = Split-Path -Parent $PSScriptRoot
$configPath = Join-Path $projectPath '.env'
if (-not (Test-Path -LiteralPath $NetBeansPath -PathType Leaf)) {
    throw 'NetBeansPath phai tro den netbeans64.exe (hoac netbeans.exe).'
}
if (-not (Test-Path -LiteralPath $configPath -PathType Leaf)) {
    throw 'Chua co .env. Sao chep .env.example thanh .env va dien thong tin MySQL.'
}
foreach ($line in Get-Content -LiteralPath $configPath -Encoding UTF8) {
    if ($line -match '^\s*([^#=\s]+)\s*=\s*(.*)$') {
        Set-Item -Path "env:$($matches[1])" -Value $matches[2]
    }
}
# User runs this script to open the interactive IDE with inherited DB variables.
Start-Process -FilePath (Resolve-Path -LiteralPath $NetBeansPath).Path
Write-Host "Trong NetBeans: File > Open Project > $projectPath"
