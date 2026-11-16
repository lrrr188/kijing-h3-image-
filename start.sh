#!/usr/bin/env bash
# start.sh — 启动 ComfyUI（端口 6006，AutoDL 自定义服务映射此端口）
export PATH=/root/miniconda3/bin:$PATH
cd /root/ComfyUI || exit 1
exec python main.py \
  --listen 0.0.0.0 \
  --port 6006 \
  --preview-method auto \
  --use-ck-attention \
  --disable-auto-launch \
  "$@"
