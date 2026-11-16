# 模型清单与获取方式

本仓库**不包含任何权重文件**。镜像内已内置；从零复现时按下面清单准备。

## 一、私有合并权重（核心资产，仅镜像内提供）

| 文件 | 大小 | 目标路径 |
|---|---|---|
| `minimax_h3_hybrid_fl2va_ref2va_b25-49-int8.safetensors` | 19.5G | `ComfyUI/models/diffusion_models/minimax/` |

说明：由官方 `fl2va` 与 `ref2va` 两个 H3 权重按 b25-49 区间 int8 合并而来。合并方法见 [notes/hybrid-merge.md](notes/hybrid-merge.md)。

## 二、可随镜像分发的模型

| 文件 | 大小 | 目标路径 |
|---|---|---|
| `h3_upscaler_lms_v0.1.safetensors` | 0.64G | `models/latent_upscale_models/` |
| `anel-lora-minimax-h3-adamw8bit-constant.safetensors` | 0.29G | `models/loras/minimax/` |
| `MysticXXX_MMH3-V2.safetensors` | 0.16G | `models/loras/minimax/` |
| `taeh3.safetensors` | 0.02G | `models/vae_approx/` |

## 三、公共模型库（软链，不占系统盘、不进镜像）

AutoDL 公共模型库只读挂载在 `/.autodl-model/data/`。开实例时勾选「公共模型」即可命中：

| 目标链接 | 公共库源路径 |
|---|---|
| `models/text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors` | `Comfy-Org/MiniMax-H3/text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors` |
| `models/vae/minimax_h3_video_vae_int8_convrot.safetensors` | `Kijai/MiniMax-H3-experimental/minimax_h3_video_vae_int8_convrot.safetensors` |
| `models/vae/minimax_h3_audio_vae_fp32.safetensors` | `Comfy-Org/MiniMax-H3/vae/minimax_h3_audio_vae_fp32.safetensors` |

建立软链：

```bash
ln -sfn /.autodl-model/data/Comfy-Org/MiniMax-H3/text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors \
        /root/ComfyUI/models/text_encoders/
ln -sfn /.autodl-model/data/Kijai/MiniMax-H3-experimental/minimax_h3_video_vae_int8_convrot.safetensors \
        /root/ComfyUI/models/vae/
ln -sfn /.autodl-model/data/Comfy-Org/MiniMax-H3/vae/minimax_h3_audio_vae_fp32.safetensors \
        /root/ComfyUI/models/vae/
```

校验（任一断链都要处理）：

```bash
find /root/ComfyUI/models -maxdepth 2 -type l ! -exec test -e {} \; -print
```

## 四、为什么权重不进 GitHub

| 位置 | 上限 | 19.5G 权重 |
|---|---|---|
| Git 普通文件 | 单文件 100MB | ✗ |
| Git LFS | 单文件 5GB、免费流量 1GB/月 | ✗ |
| GitHub Release 附件 | 单文件 2GB | ✗ |

权重只走两条路：**打进 AutoDL 镜像**，或**放对象存储/网盘由脚本下载**。
