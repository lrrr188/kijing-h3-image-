#!/usr/bin/env bash
# models.sh — 建目录 + 挂公共模型软链 + 打印缺失清单
set -uo pipefail

COMFY="${COMFY:-/root/ComfyUI}"
PUB="/.autodl-model/data"

mkdir -p "$COMFY/models"/{diffusion_models/minimax,latent_upscale_models,loras/minimax,vae_approx,text_encoders,vae}

link() {
  local src="$1" dst="$2"
  if [ -e "$src" ]; then
    mkdir -p "$(dirname "$dst")"
    ln -sfn "$src" "$dst"
    echo "  ✓ $(basename "$dst")"
  else
    echo "  ✗ 公共库缺少：$src"
  fi
}

echo "== 公共模型软链 =="
link "$PUB/Comfy-Org/MiniMax-H3/text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors" \
     "$COMFY/models/text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors"
link "$PUB/Kijai/MiniMax-H3-experimental/minimax_h3_video_vae_int8_convrot.safetensors" \
     "$COMFY/models/vae/minimax_h3_video_vae_int8_convrot.safetensors"
link "$PUB/Comfy-Org/MiniMax-H3/vae/minimax_h3_audio_vae_fp32.safetensors" \
     "$COMFY/models/vae/minimax_h3_audio_vae_fp32.safetensors"

echo
echo "== 需自行准备的本地权重 =="
for f in \
  "$COMFY/models/diffusion_models/minimax/minimax_h3_hybrid_fl2va_ref2va_b25-49-int8.safetensors" \
  "$COMFY/models/latent_upscale_models/h3_upscaler_lms_v0.1.safetensors" \
  "$COMFY/models/loras/minimax/anel-lora-minimax-h3-adamw8bit-constant.safetensors" \
  "$COMFY/models/loras/minimax/MysticXXX_MMH3-V2.safetensors" \
  "$COMFY/models/vae_approx/taeh3.safetensors" ; do
  if [ -e "$f" ]; then echo "  ✓ $(basename "$f")"; else echo "  ✗ 缺失 $(basename "$f")"; fi
done

echo
echo "== 断链检查 =="
n=$(find "$COMFY/models" -maxdepth 2 -type l ! -exec test -e {} \; -print 2>/dev/null | wc -l | tr -d ' ')
echo "  断链数：$n"
[ "$n" -gt 0 ] && find "$COMFY/models" -maxdepth 2 -type l ! -exec test -e {} \; -print 2>/dev/null
exit 0
