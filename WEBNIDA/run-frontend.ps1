$ErrorActionPreference = "Stop"

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location (Join-Path $here "frontend")

Write-Host "Instalando dependencias (si es necesario)..." -ForegroundColor Cyan
if (-not (Test-Path -LiteralPath ".\\node_modules")) {
  npm install
}

Write-Host "Frontend Next en http://localhost:3000" -ForegroundColor Cyan
npm run dev

