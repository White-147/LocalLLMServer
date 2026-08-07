@echo off
chcp 65001 >nul
REM ============================================================
REM  Local LLM Server 启动脚本（llama.cpp）
REM
REM  用法:  start-server.bat <模型路径> [端口]
REM  示例:  start-server.bat D:\models\DeepSeek-Coder-V2-Lite-Instruct-Q4_K_M.gguf 8080
REM
REM  依赖:  llama-server 可执行文件需在 PATH 中，
REM         或通过环境变量 LLAMA_SERVER 指定完整路径
REM ============================================================
setlocal

if "%~1"=="" (
    echo 用法: start-server.bat ^<模型路径^> [端口]
    exit /b 1
)

set "MODEL=%~1"
set "PORT=%~2"
if "%PORT%"=="" set "PORT=8080"

if defined LLAMA_SERVER (
    set "BIN=%LLAMA_SERVER%"
) else (
    set "BIN=llama-server"
)

echo 模型: %MODEL%
echo 端口: %PORT%
echo 启动中...

"%BIN%" -m "%MODEL%" ^
    -ngl 5 ^
    -c 16384 ^
    --host 127.0.0.1 ^
    --port %PORT% ^
    -lv 1 ^
    --flash-attn on ^
    -b 1024 ^
    --threads 12
