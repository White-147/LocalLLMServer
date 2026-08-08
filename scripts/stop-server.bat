@echo off
chcp 65001 >nul
REM ============================================================
REM  停止本地 LLM 服务（按端口结束监听进程）
REM  用法: stop-server.bat [端口]   默认 8080
REM ============================================================
setlocal
set "PORT=%~1"
if "%PORT%"=="" set "PORT=8080"

echo 查找端口 %PORT% 的监听进程...
set "FOUND="
for /f "tokens=5" %%p in ('netstat -ano ^| findstr /r /c:":%PORT% .*LISTENING"') do (
    echo 找到进程 PID %%p，正在结束...
    taskkill /PID %%p /T /F >nul 2>&1
    set "FOUND=1"
)
if not defined FOUND echo 端口 %PORT% 没有监听中的本地 LLM 服务。
echo 完成。
