# models — GGUF 模型文件（不纳入版本库）

本目录存放本地推理用的 GGUF 模型，体积 GB 级，已被 `.gitignore` 排除，**不会随仓库上传**。

## 模型

| 项目 | 值 |
| --- | --- |
| 文件名 | `deepseek-coder-v2-lite-instruct-q4_k_m.gguf` |
| 大小 | 约 9.7 GB |
| 模型 | DeepSeek-Coder-V2-Lite-Instruct（16B MoE，Q4_K_M 量化） |
| 来源 | HuggingFace：[legionarius/DeepSeek-Coder-V2-Lite-Instruct-Q4_K_M-GGUF](https://huggingface.co/legionarius/DeepSeek-Coder-V2-Lite-Instruct-Q4_K_M-GGUF/blob/main/deepseek-coder-v2-lite-instruct-q4_k_m.gguf) |

## 下载

```bash
# 方式一：huggingface-cli
huggingface-cli download legionarius/DeepSeek-Coder-V2-Lite-Instruct-Q4_K_M-GGUF \
  deepseek-coder-v2-lite-instruct-q4_k_m.gguf --local-dir .

# 方式二：浏览器直接下载 GGUF 文件后放入本目录
```

## 换机器复现

clone 本仓库不会包含模型文件，需按上面方式下载后放入本目录；
`scripts\start-server.bat` 默认读取本目录模型，放入即用。
