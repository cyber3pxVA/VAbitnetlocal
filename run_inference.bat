@echo off
REM Quick inference test script for VABitNet
REM Run this after setup to test the model

echo ============================================================
echo   VABitNet - Quick Inference Test
echo ============================================================
echo.

set "MODEL_PATH=models\bitnet_b1_58-large\ggml-model-tl2.gguf"
set "BINARY_PATH=build\bin\llama-cli.exe"

if not exist "%MODEL_PATH%" (
    echo [ERROR] Model not found: %MODEL_PATH%
    echo Please run model conversion first:
    echo   python utils/convert-hf-to-gguf-bitnet.py models/bitnet_b1_58-large --outtype tl2
    pause
    exit /b 1
)

if not exist "%BINARY_PATH%" (
    echo [ERROR] Binary not found: %BINARY_PATH%
    echo Please build the project first: BUILD_NOW.bat
    pause
    exit /b 1
)

echo Running inference with BitNet model...
echo Model: bitnet_b1_58-large (0.7B parameters)
echo.

%BINARY_PATH% -m %MODEL_PATH% -p "The meaning of life is" -n 100 --temp 0.7

echo.
echo ============================================================
echo   Inference complete!
echo ============================================================
pause
