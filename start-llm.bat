@echo off
chcp 65001 >nul
REM ============================================================
REM  Local LLM Server 启动脚本（llama.cpp）
REM  用法: start-llm.bat [端口]    默认端口 8080
REM  模型: %~dp0models\deepseek-coder-v2-lite-instruct-q4_k_m.gguf
REM  程序: %~dp0vendor\llama\llama-server.exe
REM  停止: 在本窗口按 Ctrl+C
REM ============================================================
setlocal

set "BIN=%~dp0vendor\llama\llama-server.exe"
set "MODEL=%~dp0models\deepseek-coder-v2-lite-instruct-q4_k_m.gguf"
set "PORT=%~1"
if "%PORT%"=="" set "PORT=8080"

if not exist "%BIN%" (
    echo [错误] 未找到 %BIN%
    echo        请从 https://github.com/ggerganov/llama.cpp/releases 下载
    echo        Windows + CUDA 版，解压后放入 vendor\llama\ 目录（见 vendor\README.md）
    exit /b 1
)
if not exist "%MODEL%" (
    echo [错误] 未找到模型 %MODEL%
    echo        请将 GGUF 模型放入 models\ 目录（见 models\README.md）
    exit /b 1
)

echo 程序: %BIN%
echo 模型: %MODEL%
echo 端口: %PORT%
echo 启动中...（停止：本窗口按 Ctrl+C）
echo.

"%BIN%" -m "%MODEL%" ^
    -ngl 5 ^
    -c 16384 ^
    --host 127.0.0.1 ^
    --port %PORT% ^
    -lv 1 ^
    --flash-attn on ^
    -b 1024 ^
    --threads 12
