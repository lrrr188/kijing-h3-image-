#!/usr/bin/env bash
# install.sh — 从零复现 开镜 KaiJing · MiniMax-H3 ComfyUI 环境
# 适用：AutoDL / Ubuntu 22.04 / Python 3.12
# 用法：bash install.sh
set -euo pipefail

ROOT="${ROOT:-/root}"
PY="${PY:-$ROOT/miniconda3/bin/python}"
PIP="${PIP:-$ROOT/miniconda3/bin/pip}"

COMFY_DIR="$ROOT/ComfyUI"
COMFY_COMMIT="eee59185ff4f43ae2d9ad122b245619d27d9daad"   # 2026-11-13

log() { printf '\n\033[1;36m== %s ==\033[0m\n' "$*"; }

log "0. 前置检查"
"$PY" -V
command -v git >/dev/null || { echo "缺少 git"; exit 1; }

# 国内加速（AutoDL 可用）
[ -f /etc/network_turbo ] && source /etc/network_turbo || true

log "1. PyTorch 2.12.1 + cu130"
"$PIP" install -q torch==2.12.1+cu130 torchvision==0.27.1+cu130 \
  --index-url https://download.pytorch.org/whl/cu130

log "2. ComfyUI @ $COMFY_COMMIT"
if [ ! -d "$COMFY_DIR/.git" ]; then
  git clone https://github.com/comfyanonymous/ComfyUI.git "$COMFY_DIR"
fi
git -C "$COMFY_DIR" fetch --all --quiet
git -C "$COMFY_DIR" checkout --quiet "$COMFY_COMMIT"
"$PIP" install -q -r "$COMFY_DIR/requirements.txt"
"$PIP" install -q numpy==2.4.6 transformers==5.23.0 safetensors==0.8.0 \
  einops==0.8.2 torchsde==0.2.6 scipy==1.18.1 \
  opencv-python-headless==5.0.0.93 pillow==12.2.0

log "3. 自定义节点（锁定 commit）"
install_node() {
  local name="$1" url="$2" commit="$3"
  local dir="$COMFY_DIR/custom_nodes/$name"
  if [ ! -d "$dir/.git" ]; then
    git clone "$url" "$dir"
  fi
  git -C "$dir" fetch --all --quiet
  git -C "$dir" checkout --quiet "$commit"
  if [ -f "$dir/requirements.txt" ]; then
    "$PIP" install -q -r "$dir/requirements.txt" || echo "  ! $name 依赖有警告，继续"
  fi
  echo "  ✓ $name @ $commit"
}

install_node ComfyMath                 https://github.com/evanspearman/ComfyMath.git                  c011772
install_node ComfyUI-KJNodes           https://github.com/kijai/ComfyUI-KJNodes.git                  b231941
install_node ComfyUI-VideoHelperSuite  https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git   4d907be
install_node comfyui-SelfLift          https://github.com/facok/comfyui-SelfLift.git                 835c3cf
install_node rgthree-comfy             https://github.com/rgthree/rgthree-comfy.git                 bc48c6a

log "4. 模型目录与软链"
bash "$(dirname "$0")/models.sh" || echo "  模型脚本有提示，按 models.md 手动补齐"

log "5. 启动脚本"
install -m 755 "$(dirname "$0")/start.sh" "$ROOT/start_comfyui.sh"
cat > "$ROOT/autostart_comfyui.sh" <<'EOS'
#!/bin/bash
LOG=/root/comfyui_autostart.log
export PATH=/root/miniconda3/bin:$PATH
echo "[$(date '+%F %T')] autostart trigger" >> "$LOG"
if ss -ltn 2>/dev/null | grep -q ':6006[[:space:]]'; then exit 0; fi
if pgrep -f 'main.py --listen' >/dev/null 2>&1; then exit 0; fi
cd /root/ComfyUI || exit 1
nohup /root/start_comfyui.sh >> "$LOG" 2>&1 &
EOS
chmod +x "$ROOT/autostart_comfyui.sh"

log "完成"
echo "启动：bash /root/start_comfyui.sh"
echo "日志：tail -f /root/comfyui_autostart.log"
