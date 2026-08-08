# vendor — llama.cpp 运行环境（不纳入版本库）

本目录存放 llama.cpp 的 Windows + CUDA 构建产物（`llama-server.exe` 及 CUDA 依赖 DLL，约 740 MB），已被 `.gitignore` 排除，**不会随仓库上传**。

## 本机内容

- `llama-server.exe`：推理服务主程序（原生提供 OpenAI 兼容 API）
- CUDA 13 依赖 DLL（`cublas64_13.dll`、`ggml-cuda.dll`、`ggml*.dll` 等）
- 其他 llama 工具（`llama-cli.exe`、`llama-bench.exe` 等）

## 来源

llama.cpp Releases（Windows + CUDA 版，版本 **b8581**）：
https://github.com/ggml-org/llama.cpp/releases?q=b8581&expanded=true

## 换机器复现

clone 本仓库不会包含二进制，需下载 llama.cpp Windows + CUDA 版，解压后放入本目录（保持 `llama-server.exe` 与全部 DLL 同目录）；`scripts\start-server.bat` 默认读取 `vendor\llama\llama-server.exe`，放入即用。
