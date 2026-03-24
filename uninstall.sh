#!/bin/bash

# Dotfiles 卸载脚本
# 用途：删除所有软链接，恢复独立配置

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}"
echo "╔════════════════════════════════════════╗"
echo "║   Dotfiles 配置卸载                    ║"
echo "╚════════════════════════════════════════╝"
echo -e "${NC}\n"

# 函数：删除软链接
remove_symlink() {
  local target=$1
  local name=$2
  
  if [ -L "$target" ]; then
    echo -e "${YELLOW}删除 $name 软链接${NC}"
    rm "$target"
    echo -e "${GREEN}  ✓ 已删除${NC}"
    
    # 查找备份文件
    local backup=$(ls -t "${target}.backup."* 2>/dev/null | head -1)
    if [ -n "$backup" ]; then
      echo -e "${YELLOW}  提示: 发现备份文件 $(basename "$backup")${NC}"
      echo -e "${YELLOW}  恢复命令: cp \"$backup\" \"$target\"${NC}"
    fi
    echo ""
  elif [ -e "$target" ]; then
    echo -e "${YELLOW}跳过 $name: 不是软链接${NC}\n"
  fi
}

echo -e "${YELLOW}=== 删除 ~/.config 下的软链接 ===${NC}\n"

# ~/.config 下的配置
CONFIG_DIRS=(
  "nvim"
  "wezterm"
  "lazygit"
  "lazydocker"
  "opencode"
  "btop"
  "neofetch"
  "raycast"
  "waveterm"
  "wireshark"
  "zed"
  "dlv"
  "uv"
)

for dir in "${CONFIG_DIRS[@]}"; do
  remove_symlink "$HOME/.config/$dir" "$dir"
done

echo -e "${YELLOW}=== 删除 ~ 目录下的软链接 ===${NC}\n"

# ~ 目录下的配置文件
remove_symlink "$HOME/.zshrc" ".zshrc"
remove_symlink "$HOME/.bashrc" ".bashrc"
remove_symlink "$HOME/.bash_profile" ".bash_profile"
remove_symlink "$HOME/.profile" ".profile"
remove_symlink "$HOME/.vimrc" ".vimrc"
remove_symlink "$HOME/.gitconfig" ".gitconfig"
remove_symlink "$HOME/.gitignore" ".gitignore"
remove_symlink "$HOME/.git_me" ".git_me"
remove_symlink "$HOME/.git_wk" ".git_wk"
remove_symlink "$HOME/.git_os" ".git_os"
remove_symlink "$HOME/.git_cc" ".git_cc"
remove_symlink "$HOME/.codex/config.toml" "codex config.toml"
remove_symlink "$HOME/.codex/mcp_config.json" "codex mcp_config.json"
remove_symlink "$HOME/.codex/rules/default.rules" "codex default.rules"

echo -e "${YELLOW}=== 删除 VSCode 系列 IDE 的软链接 ===${NC}\n"

# VSCode 系列 IDE
VSCODE_IDES=(
    "Kiro"
    "Cursor"
    "Trae CN"
    "Trae"
    "Antigravity"
    "Comate"
    "Code"
    "CodeBuddy"
    "Lingma"
    "Windsurf"
)

for ide in "${VSCODE_IDES[@]}"; do
  IDE_DIR="$HOME/Library/Application Support/$ide/User"
  if [ -d "$IDE_DIR" ]; then
    remove_symlink "$IDE_DIR/keybindings.json" "$ide keybindings"
    remove_symlink "$IDE_DIR/settings.json" "$ide settings"
  fi
done

echo -e "${GREEN}"
echo "╔════════════════════════════════════════╗"
echo "║   ✓ 卸载完成！                         ║"
echo "╚════════════════════════════════════════╝"
echo -e "${NC}\n"

echo -e "${YELLOW}提示：${NC}"
echo -e "  1. 所有软链接已删除"
echo -e "  2. 如需恢复配置，请从备份文件复制"
echo -e "  3. 备份文件格式: ${YELLOW}文件名.backup.时间戳${NC}\n"
