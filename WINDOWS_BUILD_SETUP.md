# Windows Build Setup Guide

This guide will help you set up the build environment on Windows 11 to compile BitNet.cpp binaries.

## Prerequisites Installation

### Option 1: Install Visual Studio 2022 (Recommended)
Download and install [Visual Studio 2022 Community Edition](https://visualstudio.microsoft.com/downloads/)

During installation, select these workloads:
- ✅ Desktop development with C++
- ✅ C++ CMake tools for Windows
- ✅ Git for Windows
- ✅ C++ Clang Compiler for Windows
- ✅ MSBuild support for LLVM (Clang-cl) toolset

### Option 2: Chocolatey Quick Install
If you have Chocolatey installed, run in PowerShell (Admin):
```powershell
choco install cmake llvm visualstudio2022buildtools -y
choco install visualstudio2022-workload-vctools -y
```

### Option 3: Manual Standalone Tools
1. Install CMake: https://cmake.org/download/
2. Install LLVM/Clang: https://github.com/llvm/llvm-project/releases
3. Install Visual Studio Build Tools: https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022

## Build Process

After installing the prerequisites:

1. **Open Developer PowerShell for VS 2022**
   - Search for "Developer PowerShell for VS 2022" in Start Menu
   - OR use regular PowerShell after running:
     ```powershell
     & "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Launch-VsDevShell.ps1"
     ```

2. **Navigate to the repository**
   ```powershell
   cd c:\DEV\VABitNet
   ```

3. **Activate the virtual environment**
   ```powershell
   .\venv\Scripts\Activate.ps1
   ```

4. **Build the project**
   ```powershell
   python setup_env.py -md models/bitnet_b1_58-large -q i2_s
   ```

5. **The compiled binaries will be in:**
   - `build\bin\Release\llama-cli.exe`
   - `build\bin\Release\llama-quantize.exe`
   - `build\bin\Release\llama-server.exe`

## Commit Binaries to Repo

After successful build:
```powershell
git add build/bin/Release/*.exe
git add build/bin/Release/*.dll
git commit -m "Add pre-built Windows binaries"
git push
```

## Usage Without Build Tools

Once binaries are committed, users can:
1. Clone the repo
2. Create venv and install Python dependencies
3. Download models using Git LFS
4. Run inference directly using the pre-built binaries

No C++ build tools required for end users!
