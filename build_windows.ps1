# BitNet.cpp Windows Build Script
# Run this in Developer PowerShell for VS 2022

param(
    [string]$Model = "bitnet_b1_58-large",
    [string]$QuantType = "i2_s"
)

Write-Host "===== BitNet.cpp Windows Build Script =====" -ForegroundColor Cyan
Write-Host ""

# Check if we're in VS Developer environment
if (-not $env:VSINSTALLDIR) {
    Write-Host "ERROR: Not in Visual Studio Developer environment!" -ForegroundColor Red
    Write-Host "Please run this script from 'Developer PowerShell for VS 2022'" -ForegroundColor Yellow
    Write-Host "Or run: & 'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Launch-VsDevShell.ps1'" -ForegroundColor Yellow
    exit 1
}

# Check if venv is activated
if (-not $env:VIRTUAL_ENV) {
    Write-Host "Activating virtual environment..." -ForegroundColor Yellow
    & ".\venv\Scripts\Activate.ps1"
}

# Check for required tools
Write-Host "Checking required tools..." -ForegroundColor Cyan

$cmake = Get-Command cmake -ErrorAction SilentlyContinue
if (-not $cmake) {
    Write-Host "ERROR: CMake not found!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ CMake found: $($cmake.Source)" -ForegroundColor Green

$clang = Get-Command clang -ErrorAction SilentlyContinue
if (-not $clang) {
    Write-Host "ERROR: Clang not found!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Clang found: $($clang.Source)" -ForegroundColor Green

# Build the project
Write-Host ""
Write-Host "Building BitNet.cpp..." -ForegroundColor Cyan
Write-Host "Model: $Model" -ForegroundColor Yellow
Write-Host "Quantization: $QuantType" -ForegroundColor Yellow
Write-Host ""

python setup_env.py -md "models/$Model" -q $QuantType

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "===== Build Successful! =====" -ForegroundColor Green
    Write-Host ""
    Write-Host "Binaries are located in:" -ForegroundColor Cyan
    Write-Host "  build\bin\Release\" -ForegroundColor White
    Write-Host ""
    Write-Host "To commit binaries to repo:" -ForegroundColor Cyan
    Write-Host "  git add build/bin/Release/*.exe" -ForegroundColor White
    Write-Host "  git add build/bin/Release/*.dll" -ForegroundColor White
    Write-Host "  git commit -m 'Add pre-built Windows binaries'" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "===== Build Failed =====" -ForegroundColor Red
    Write-Host "Check logs directory for details" -ForegroundColor Yellow
    exit 1
}
