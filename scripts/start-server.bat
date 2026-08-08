@echo off
chcp 65001 >nul
REM ============================================================
REM  Local LLM Server 启动脚本（llama.cpp）
REM
REM  用法:  start-server.bat [模型路径] [端口]
REM
REM  默认值（本机已内置）:
REM    程序  ..\vendor\llama\llama-server.exe
REM    模型  ..\models\deepseek-coder-v2-lite-instruct-q4_k_m.gguf
REM    端口  8080
REM
REM  显式传参可覆盖默认值，例如:
REM    start-server.bat D:\other\model.gguf 9090
REM ============================================================
setlocal

set "ROOT=%~dp0.."
set "BIN=%ROOT%\vendor\llama\llama-server.exe"

set "MODEL=%~1"
if "%MODEL%"=="" set "MODEL=%ROOT%\models\deepseek-coder-v2-lite-instruct-q4_k_m.gguf"

set "PORT=%~2"
if "%PORT%"=="" set "PORT=8080"

REM 可执行文件与模型存在性检查
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
