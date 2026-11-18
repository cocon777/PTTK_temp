$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot
Get-Content -LiteralPath (Join-Path $PSScriptRoot '.env') -Encoding UTF8 | ForEach-Object {
    if ($_ -match '^\s*([^#=\s]+)\s*=\s*(.*)$') {
        Set-Item -Path "env:$($matches[1])" -Value $matches[2]
    }
}
mvn clean package cargo:run
