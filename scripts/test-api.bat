@echo off
chcp 65001 >nul
REM ============================================================
REM  本地 LLM 服务连通性自检
REM  用法: test-api.bat [端口]   默认 8080
REM ============================================================
setlocal
set "PORT=%~1"
if "%PORT%"=="" set "PORT=8080"
set "BASE=http://127.0.0.1:%PORT%"

echo [1/2] GET /v1/models
curl -s %BASE%/v1/models
echo.
echo.
echo [2/2] POST /v1/chat/completions
curl -s %BASE%/v1/chat/completions ^
    -H "Content-Type: application/json" ^
    -d "{\"model\":\"deepseek-coder-v2-lite\",\"messages\":[{\"role\":\"user\",\"content\":\"用一句话介绍你自己\"}],\"max_tokens\":100}"
echo.
