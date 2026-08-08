# Local LLM Server — llama.cpp 本地大模型推理服务

在 Windows 上基于 [llama.cpp](https://github.com/ggerganov/llama.cpp) 部署本地大模型推理服务，模型使用 **DeepSeek-Coder-V2-Lite-Instruct（Q4_K_M 量化版）**，对外提供 **OpenAI 兼容 API**（`/v1/chat/completions`），可被任何支持 OpenAI 接口的工具/代码直接调用。

> 面向场景：代码生成与编程问答。数据完全本地处理，不依赖外网，适合需要隐私/离线环境的开发工作流。

## 为什么选这套方案

| 方案 | 对比结论 |
| --- | --- |
| **llama.cpp（本方案）** | 单可执行文件，无 Python 依赖；GGUF 量化成熟；CPU/GPU 混合推理灵活；`llama-server` 原生提供 OpenAI 兼容 API，零胶水代码 |
| Ollama | 封装更友好，但多一层守护进程与模型管理，量化选项少，自定义参数（gpu_layers 等）不如 llama.cpp 直接 |
| vLLM | 高吞吐，但主要面向 Linux + 多卡服务器场景，Windows 支持弱，对本机单卡场景过重 |
| 在线 API | 需要联网、有数据外发顾虑，成本随用量增长 |

对「单机、显卡显存有限、要完全本地」的场景，llama.cpp 是最直接的选择。

## 硬件与环境

| 项目 | 配置 |
| --- | --- |
| 操作系统 | Windows 10/11（x64） |
| GPU | NVIDIA GeForce RTX 3060 Laptop（6 GB 显存，CUDA 13，compute 8.6） |
| 内存 | 实测运行占用约 **13.8 GB**（16K 上下文） |
| 推理后端 | GPU 部分卸载（`-ngl 5`）+ CPU 12 线程混合推理 |

## 模型

- **DeepSeek-Coder-V2-Lite-Instruct**（16B MoE 架构的量化轻量版）
- 量化格式：GGUF **Q4_K_M**，文件约 **10.3 GB**
- 下载来源：HuggingFace（`deepseek-ai/DeepSeek-Coder-V2-Lite-Instruct-GGUF`）

## 快速开始

### 1. 启动服务

```bat
scripts\start-server.bat
```

默认读取 `models\deepseek-coder-v2-lite-instruct-q4_k_m.gguf` 模型、`vendor\llama\llama-server.exe` 程序，监听 `127.0.0.1:8080`；也可显式覆盖：

```bat
scripts\start-server.bat [模型路径] [端口]
```

### 2. 停止服务

```bat
scripts\stop-server.bat        :: 默认端口 8080，可传参: stop-server.bat 9090
```

按端口结束监听进程。

### 3. 验证服务

```bat
scripts\test-api.bat 8080
```

一次跑通 `GET /v1/models` 与 `POST /v1/chat/completions`。

## OpenAI 兼容 API 用法

```bash
# 列出可用模型
curl http://127.0.0.1:8080/v1/models

# 对话补全
curl http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "DeepSeek-Coder-V2-Lite-Instruct-Q4_K_M.gguf",
    "messages": [{"role": "user", "content": "用 Java 写一个二分查找"}],
    "max_tokens": 200,
    "temperature": 0.3
  }'
```

该接口与 OpenAI 格式兼容，可将 `base_url` 指向 `http://127.0.0.1:8080/v1` 接入各类支持 OpenAI API 的客户端或框架。

## 实测性能（本机）

| 指标 | 数值 |
| --- | --- |
| 模型加载 | ~5 秒内可响应请求 |
| Prompt 处理速度 | **~32.6 tokens/s**（20 tokens 输入） |
| 生成速度 | **~14.1 tokens/s**（200 tokens 输出） |
| 上下文长度 | 16384 tokens（`-c 16384`） |
| 运行内存占用 | 约 13.8 GB |

实测样例（Java 二分查找提问）在 14.8 秒内完成 200 token 输出，回答含完整可运行代码与说明。

## 参数说明

| 参数 | 含义 | 本机取值 |
| --- | --- | --- |
| `-ngl 5` | 将模型前 5 层卸载到 GPU（显存 6 GB 的限制下部分卸载） | 5 |
| `-c 16384` | 上下文窗口 16K | 16384 |
| `--flash-attn on` | 启用 FlashAttention，降低显存占用并加速长上下文 | on |
| `-b 1024` | 批处理大小 | 1024 |
| `--threads 12` | CPU 推理线程数 | 12 |
| `-lv 1` | 日志详细级别 | 1 |

显存更大的机器可提高 `-ngl` 值，将更多层卸载到 GPU，生成速度会随之提升。

## 常见问题

- **启动即退出 / 无输出**：确认 CUDA 相关 DLL（`cublas64_13.dll`、`cudart64_13.dll` 等）与 `llama-server.exe` 在同一目录；确认显卡驱动支持所用 CUDA 版本。
- **请求报 500 / UTF-8 错误**：请求体必须为 UTF-8 编码（Windows 命令行直接内联中文 JSON 时注意编码）。
- **内存不足**：调小 `-c`（如 8192）可显著降低运行内存。
- **端口被占用**：更换 `--port` 参数。

## 目录结构

```
├── models/
│   ├── deepseek-coder-v2-lite-instruct-q4_k_m.gguf   # GGUF 模型（约 9.7 GB，不入库）
│   └── README.md                                     # 模型说明与下载方式
├── vendor/
│   ├── llama/                                        # llama.cpp 二进制（约 740 MB，不入库）
│   └── README.md                                     # 运行环境说明
├── scripts/
│   ├── start-server.bat   # 启动（默认项目内模型/程序，可参数覆盖）
│   ├── stop-server.bat    # 停止（按端口杀监听进程）
│   └── test-api.bat       # 连通性自检（models + chat 一次跑通）
└── README.md
```

## 换机器复现

模型（约 9.7 GB）与 llama.cpp 二进制（约 740 MB）体积过大，**不纳入版本库**（见 `.gitignore`），clone 后需：

1. 下载 GGUF 模型放入 `models\`（见 `models\README.md`）
2. 下载 llama.cpp Windows + CUDA 版放入 `vendor\llama\`（见 `vendor\README.md`）

完成后 `scripts\start-server.bat` 即可直接启动，行为与本机一致。
