# Quick Setup Script for End Users (No Build Tools Required)
# Run this after cloning the repo

param(
    [switch]$SkipVenv
)

Write-Host "===== VABitNet Quick Setup (No Build Tools) =====" -ForegroundColor Cyan
Write-Host ""

# Check Git LFS
Write-Host "Checking Git LFS..." -ForegroundColor Cyan
$gitlfs = Get-Command git-lfs -ErrorAction SilentlyContinue
if (-not $gitlfs) {
    Write-Host "WARNING: Git LFS not found!" -ForegroundColor Yellow
    Write-Host "Install it from: https://git-lfs.github.com/" -ForegroundColor Yellow
    Write-Host "Or run: choco install git-lfs" -ForegroundColor Yellow
    $response = Read-Host "Continue anyway? (y/n)"
    if ($response -ne 'y') { exit 1 }
} else {
    Write-Host "✓ Git LFS installed" -ForegroundColor Green
    git lfs install
}

# Create virtual environment
if (-not $SkipVenv) {
    if (-not (Test-Path "venv")) {
        Write-Host ""
        Write-Host "Creating Python virtual environment..." -ForegroundColor Cyan
        python -m venv venv
        if ($LASTEXITCODE -ne 0) {
            Write-Host "ERROR: Failed to create virtual environment!" -ForegroundColor Red
            exit 1
        }
    }

    Write-Host "Activating virtual environment..." -ForegroundColor Cyan
    & ".\venv\Scripts\Activate.ps1"
}

# Install Python dependencies
Write-Host ""
Write-Host "Installing Python dependencies..." -ForegroundColor Cyan
python -m pip install --upgrade pip
pip install -r requirements.txt

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to install dependencies!" -ForegroundColor Red
    exit 1
}

# Check if binaries exist
Write-Host ""
Write-Host "Checking for pre-built binaries..." -ForegroundColor Cyan
$binaryPath = "build\bin\Release\llama-cli.exe"
if (Test-Path $binaryPath) {
    Write-Host "✓ Pre-built binaries found!" -ForegroundColor Green
} else {
    Write-Host "WARNING: Pre-built binaries not found!" -ForegroundColor Yellow
    Write-Host "You will need to build from source." -ForegroundColor Yellow
    Write-Host "See WINDOWS_BUILD_SETUP.md for instructions." -ForegroundColor Yellow
}

# Check models
Write-Host ""
Write-Host "Checking for models..." -ForegroundColor Cyan
if (Test-Path "models\bitnet_b1_58-large\*.gguf") {
    Write-Host "✓ Model found!" -ForegroundColor Green
} else {
    Write-Host "INFO: No models found." -ForegroundColor Yellow
    Write-Host "Download a model with:" -ForegroundColor Cyan
    Write-Host "  cd models" -ForegroundColor White
    Write-Host "  git clone https://huggingface.co/1bitLLM/bitnet_b1_58-large" -ForegroundColor White
}

Write-Host ""
Write-Host "===== Setup Complete! =====" -ForegroundColor Green
Write-Host ""
Write-Host "To run inference:" -ForegroundColor Cyan
Write-Host '  python run_inference.py -m models/bitnet_b1_58-large/ggml-model-i2_s.gguf -p "Hello, world!" -cnv' -ForegroundColor White
Write-Host ""
