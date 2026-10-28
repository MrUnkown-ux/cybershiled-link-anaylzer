# CyberShield PowerShell Runner (No Docker Required)
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "   CyberShield: Safe Link Analyzer & Virtual Browser" -ForegroundColor Cyan
Write-Host "              (100% Native Local Run)" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

$rootPath = $PSScriptRoot
if (-not $rootPath) { $rootPath = Get-Location }

# Start Backend
Write-Host "[1/2] Launching Backend on http://127.0.0.1:8000 ..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$rootPath\backend'; python -m uvicorn app.main:app --host 127.0.0.1 --port 8000"

Start-Sleep -Seconds 3

# Start Frontend
Write-Host "[2/2] Launching Frontend on http://localhost:5173 ..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$rootPath\frontend'; npm run dev"

Start-Sleep -Seconds 2

Write-Host ""
Write-Host "Opening Dashboard in your default browser..." -ForegroundColor Green
Start-Process "http://localhost:5173"

Write-Host "CyberShield is now active!" -ForegroundColor Cyan
Write-Host "  - UI: http://localhost:5173"
Write-Host "  - API: http://localhost:8000/docs"
