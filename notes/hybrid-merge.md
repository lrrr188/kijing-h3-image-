# hybrid 权重合并说明（待补全）

镜像内 `minimax_h3_hybrid_fl2va_ref2va_b25-49-int8.safetensors`（19.5G）是把官方 `fl2va` 与 `ref2va` 两个 H3 权重合并后的私有版本。

## 已知信息

| 项 | 值 |
|---|---|
| 输出文件 | `minimax_h3_hybrid_fl2va_ref2va_b25-49-int8.safetensors` |
| 大小 | 19.5G |
| 量化 | int8 |
| 步数区间 | b25-49 |
| 上游来源 | `Comfy-Org/MiniMax-H3/diffusion_models/`：`minimax_h3_fl2va_*` 与 `minimax_h3_ref2va_*`（bf16 / int8_convrot / pruned_int8_convrot 三种形态） |

## 待补全（发布社区镜像前建议补齐）

- [ ] 合并用的具体工具与命令（脚本或 ComfyUI 节点名）
- [ ] 两个源权重选用的是哪个变体（bf16 还是 int8_convrot）
- [ ] b25-49 的含义与作用（是采样步数区间裁剪，还是层区间）
- [ ] 合并后的校验方式（文件大小 / 加载测试 / 出图对比）

## 为什么建议把方法写进仓库，而不是只给权重文件

三个理由，越想越明显：

1. **仓库体积**：方法几十行，权重 19.5G，GitHub 都放不下后者。
2. **可复现**：别人拿到权重只能照搬；拿到方法才能在你换模型时跟上。
3. **控分发**：权重靠镜像分发等于一次送光，方法留在自己手里才是长期壁垒。

写好之后，把本文件改名成 `hybrid-merge.md` 并补上实际命令即可。
