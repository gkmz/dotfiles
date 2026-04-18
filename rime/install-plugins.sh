#!/usr/bin/env bash
# 可选插件：全本地资源，经 SSH 从 GitHub 克隆；不收集输入内容
set -euo pipefail

RIME_DIR="${RIME_DIR:-$HOME/Library/Rime}"
TMP="$(mktemp -d)"
cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

usage() {
  echo "用法: $0 <emoji|english|all>"
  echo "  emoji    rime-emoji（opencc + 候选绘文字）"
  echo "  english  rime-easy-en（中文模式下英文单词混输，词库约十几 MB）"
  echo "  all      以上两项"
  echo ""
  echo "本脚本仅使用 SSH 克隆（git@github.com:...），需本机已配置 GitHub SSH 密钥并通过："
  echo "  ssh -T git@github.com"
  echo ""
  echo "可选环境变量："
  echo "  RIME_GITHUB_SSH_HOST   默认 github.com；若 ~/.ssh/config 里用了别名可改为对应 Host"
  echo ""
  echo "完成后在鼠须管菜单选择「重新部署」。"
}

# 使用 SSH 拉取 GitHub 上 owner/repo（浅克隆）
clone_github_ssh() {
  local repo="$1"
  local dest="$2"
  local host="${RIME_GITHUB_SSH_HOST:-github.com}"
  local url="git@${host}:${repo}.git"

  rm -rf "$dest"
  mkdir -p "$(dirname "$dest")"

  echo "正在克隆（SSH）: $url"
  # GIT_TERMINAL_PROMPT=0：非交互环境下不因密码提示挂住
  GIT_TERMINAL_PROMPT=0 git clone --depth 1 "$url" "$dest"
  echo "✓ 克隆成功"
}

install_emoji() {
  clone_github_ssh "rime/rime-emoji" "$TMP/rime-emoji"
  cp -R "$TMP/rime-emoji/opencc" "$RIME_DIR/"
  cp "$TMP/rime-emoji/emoji_suggestion.yaml" "$RIME_DIR/"
  echo "✓ rime-emoji 已复制到 $RIME_DIR"
}

install_english() {
  clone_github_ssh "BlindingDark/rime-easy-en" "$TMP/rime-easy-en"
  local src="$TMP/rime-easy-en"
  cp "$src/easy_en.yaml" "$src/easy_en.schema.yaml" "$src/easy_en.dict.yaml" "$RIME_DIR/"
  mkdir -p "$RIME_DIR/lua"
  cp "$src/lua/easy_en.lua" "$RIME_DIR/lua/"
  # 注意：Bash 5 下「$RIME_DIR」后若紧跟全角「（」会误解析变量名，须用花括号
  echo "✓ rime-easy-en 已复制到 ${RIME_DIR}（含词库，首次部署可能稍慢）"
}

mkdir -p "$RIME_DIR"

case "${1:-}" in
  emoji)
    install_emoji
    ;;
  english)
    install_english
    ;;
  all)
    install_english
    install_emoji
    ;;
  *)
    usage
    exit 1
    ;;
esac

echo ""
echo "请在鼠须管菜单 → 重新部署。"
