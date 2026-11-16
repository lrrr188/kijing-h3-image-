# 开镜 KaiJing · MiniMax-H3 视频生成环境（AutoDL 镜像）

在 AutoDL 上开一台带显卡的机器，选择本镜像，几分钟内跑起 **ComfyUI + MiniMax-H3** 视频生成工作流。

> 本仓库是**镜像的项目主页与复现说明**，不含镜像文件本身（系统盘快照约 25G，无法上传 GitHub）。
> 镜像本体在 AutoDL「镜像」中保存与共享/发布。

---

## 一、镜像信息

| 项 | 值 |
|---|---|
| 镜像名 | `kijing-h3-v1.1.55-20261116`（以 AutoDL 控制台实际命名为准） |
| 底座系统 | Ubuntu 22.04.5 LTS |
| 系统盘 | 30G（镜像占用约 25G，其中 20G 为模型权重） |
| 建议显存 | ≥ 24G（H3 int8 混合权重） |
| 服务端口 | `6006`（ComfyUI WebUI） |
| 启动方式 | 开机自动拉起 `autostart_comfyui.sh`，或手动 `bash /root/start_comfyui.sh` |

## 二、环境组成

| 组件 | 版本 |
|---|---|
| Python | 3.12.3（`/root/miniconda3`） |
| PyTorch | 2.12.1+cu130 |
| torchvision | 0.27.1+cu130 |
| numpy | 2.4.6 |
| transformers | 5.23.0 |
| safetensors | 0.8.0 |
| ComfyUI | `eee5918`（2026-11-13） |

### 自定义节点

| 节点 | 来源 | 锁定 commit |
|---|---|---|
| ComfyMath | evanspearman/ComfyMath | `c011772` |
| ComfyUI-KJNodes | kijai/ComfyUI-KJNodes | `b231941` |
| ComfyUI-VideoHelperSuite | Kosinkadink/ComfyUI-VideoHelperSuite | `4d907be` |
| comfyui-SelfLift | facok/comfyui-SelfLift | `835c3cf` |
| rgthree-comfy | rgthree/rgthree-comfy | `bc48c6a` |

## 三、模型清单

| 模型 | 大小 | 位置 | 来源 |
|---|---|---|---|
| `minimax_h3_hybrid_fl2va_ref2va_b25-49-int8.safetensors` | 19.5G | `models/diffusion_models/minimax/` | **私有合并权重**，镜像内自带 |
| `h3_upscaler_lms_v0.1.safetensors` | 0.64G | `models/latent_upscale_models/` | 镜像内自带 |
| `anel-lora-minimax-h3-adamw8bit-constant.safetensors` | 0.29G | `models/loras/minimax/` | 镜像内自带 |
| `MysticXXX_MMH3-V2.safetensors` | 0.16G | `models/loras/minimax/` | 镜像内自带 |
| `taeh3.safetensors` | 0.02G | `models/vae_approx/` | 镜像内自带 |
| `qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors` | — | `models/text_encoders/` | **软链** → AutoDL 公共模型库 |
| `minimax_h3_video_vae_int8_convrot.safetensors` | — | `models/vae/` | **软链** → AutoDL 公共模型库 |
| `minimax_h3_audio_vae_fp32.safetensors` | — | `models/vae/` | **软链** → AutoDL 公共模型库 |

### 关键：开实例时必须挂公共模型

后三项是软链，指向只读的 `/.autodl-model/data/`。**创建/开机时要在「公共模型」里勾选 MiniMax-H3 相关模型**，否则软链悬空，ComfyUI 会报模型缺失。详见 [models.md](models.md)。

## 四、使用步骤

1. 在 AutoDL 控制台创建实例，镜像选「社区镜像」中的本镜像（或「共享给我的」）
2. 勾选公共模型：`Comfy-Org/MiniMax-H3`（text_encoder + vae）
3. 开机后执行：
   ```bash
   bash /root/autostart_comfyui.sh
   tail -f /root/comfyui_autostart.log
   ```
4. 日志出现 `To see the GUI go to: http://0.0.0.0:6006` 即成功
5. AutoDL「自定义服务」端口填 `6006` → 打开 WebUI

## 五、常见问题

| 现象 | 原因 | 处理 |
|---|---|---|
| `Found no NVIDIA driver on your system` | 用的是无卡模式实例 | 换带 GPU 的实例开机 |
| 启动报模型缺失 | 没挂公共模型 | 关机 → 「公共模型」勾选 MiniMax-H3 → 重开 |
| 6006 端口无响应 | ComfyUI 未起来 | 看 `/root/comfyui_autostart.log` 末尾报错 |
| 系统盘写满 | 镜像 25G + 生成输出 | 把输出目录指到数据盘 `/root/autodl-tmp/output` |

## 六、从零复现（不用镜像）

```bash
bash install.sh    # 装 ComfyUI + 节点 + 依赖
bash start.sh      # 启动
```
模型需要自行准备，清单与获取方式见 [models.md](models.md)。

## 七、许可

- 本仓库的脚本与说明：随项目分发
- ComfyUI 及各自定义节点：遵循各自上游许可
- MiniMax-H3 权重：遵循上游模型许可，**本仓库不包含任何权重文件**
