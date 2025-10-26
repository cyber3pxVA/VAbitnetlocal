@echo off
REM ================================================================
REM  VABitNet Complete Build - Run this in CMD outside VS Code
REM ================================================================

echo.
echo ============================================================
echo   VABitNet Build Process
echo ============================================================
echo.
echo IMPORTANT: Run this in a regular CMD window (not VS Code)
echo This will take 5-10 minutes to complete
echo.
echo Starting in 3 seconds...
timeout /t 3 /nobreak >nul

REM Setup environment
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat" >nul 2>&1
set "PATH=C:\Program Files\CMake\bin;C:\Program Files\LLVM\bin;%LOCALAPPDATA%\Microsoft\WinGet\Links;%PATH%"

cd /d C:\DEV\VABitNet

REM Clean
echo [Step 1/5] Cleaning...
rmdir /s /q build 2>nul
rmdir /s /q logs 2>nul
mkdir logs

REM Activate venv and generate code
echo [Step 2/5] Generating kernel code...
call venv\Scripts\activate.bat
python utils/codegen_tl2.py --model bitnet_b1_58-large --BM 256,128,256 --BK 96,192,96 --bm 32,32,32 > logs\codegen.log 2>&1
if errorlevel 1 (
    echo ERROR: Code generation failed!
    type logs\codegen.log
    pause
    exit /b 1
)
echo   OK

REM Configure
echo [Step 3/5] Configuring with CMake...
cmake -B build -G Ninja -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Release -DBITNET_X86_TL2=ON -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded" > logs\cmake.log 2>&1
if errorlevel 1 (
    echo ERROR: CMake configuration failed!
    type logs\cmake.log
    pause
    exit /b 1
)
echo   OK

REM Build - This is the long step
echo [Step 4/5] Compiling (~120 files, 5-10 minutes)...
echo   Progress will show below:
echo.
cmake --build build --config Release 2>&1
set BUILD_RESULT=%ERRORLEVEL%

REM Save build output
cmake --build build --config Release > logs\build.log 2>&1

if %BUILD_RESULT% neq 0 (
    echo.
    echo ERROR: Build failed!
    echo Check logs\build.log for details
    pause
    exit /b 1
)

REM Verify
echo.
echo [Step 5/5] Verifying binaries...
if exist "build\bin\llama-cli.exe" (
    echo   [OK] llama-cli.exe
) else (
    echo   [FAIL] llama-cli.exe not found!
)

if exist "build\bin\llama-quantize.exe" (
    echo   [OK] llama-quantize.exe  
) else (
    echo   [FAIL] llama-quantize.exe not found!
)

if exist "build\bin\llama-server.exe" (
    echo   [OK] llama-server.exe
) else (
    echo   [FAIL] llama-server.exe not found!
)

echo.
echo ============================================================
echo   BUILD COMPLETE!
echo ============================================================
echo.
echo Binary files:
dir build\bin\*.exe
echo.
echo Next: Test the binaries and commit to repository
echo.
pause
