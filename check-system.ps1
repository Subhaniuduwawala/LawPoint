# LawPoint System Check Script
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "   LawPoint System Check" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

$allGood = $true

# Check Node.js
Write-Host "Checking Node.js..." -NoNewline
try {
    $nodeVersion = node --version 2>$null
    if ($nodeVersion) {
        Write-Host " Found $nodeVersion" -ForegroundColor Green
    } else {
        Write-Host " Not found" -ForegroundColor Red
        $allGood = $false
    }
} catch {
    Write-Host " Not found" -ForegroundColor Red
    $allGood = $false
}

# Check MongoDB Service
Write-Host "Checking MongoDB service..." -NoNewline
$mongoService = Get-Service -Name "MongoDB" -ErrorAction SilentlyContinue
if ($mongoService) {
    if ($mongoService.Status -eq "Running") {
        Write-Host " Running" -ForegroundColor Green
    } else {
        Write-Host " Installed but not running" -ForegroundColor Yellow
        Write-Host "   Run: Start-Service MongoDB" -ForegroundColor Yellow
        $allGood = $false
    }
} else {
    Write-Host " Not found" -ForegroundColor Red
    $allGood = $false
}

# Check MongoDB Port
Write-Host "Checking MongoDB port 27017..." -NoNewline
$mongoPort = Test-NetConnection -ComputerName localhost -Port 27017 -WarningAction SilentlyContinue -InformationLevel Quiet
if ($mongoPort) {
    Write-Host " Accessible" -ForegroundColor Green
} else {
    Write-Host " Not accessible" -ForegroundColor Red
    $allGood = $false
}

# Check backend node_modules
Write-Host "Checking backend dependencies..." -NoNewline
if (Test-Path ".\backend\node_modules") {
    Write-Host " Installed" -ForegroundColor Green
} else {
    Write-Host " Not installed" -ForegroundColor Red
    Write-Host "   Run: cd backend ; npm install" -ForegroundColor Yellow
    $allGood = $false
}

# Check frontend node_modules
Write-Host "Checking frontend dependencies..." -NoNewline
if (Test-Path ".\frontend\node_modules") {
    Write-Host " Installed" -ForegroundColor Green
} else {
    Write-Host " Not installed" -ForegroundColor Red
    Write-Host "   Run: cd frontend ; npm install" -ForegroundColor Yellow
    $allGood = $false
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan

if ($allGood) {
    Write-Host "All systems ready!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Start the app:" -ForegroundColor White
    Write-Host "  .\start-dev.bat" -ForegroundColor Yellow
} else {
    Write-Host "Some issues found" -ForegroundColor Yellow
    Write-Host "Fix the issues above before starting" -ForegroundColor Yellow
}

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
