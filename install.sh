#!/bin/bash

# Dotfiles 安装脚本
# 用途：一键安装所有配置

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${GREEN}"
echo "╔════════════════════════════════════════╗"
echo "║   Dotfiles 配置安装                    ║"
echo "╚════════════════════════════════════════╝"
echo -e "${NC}\n"

# 函数：创建软链接
create_symlink() {
  local source=$1
  local target=$2
  local name=$3
  
  echo -e "${YELLOW}安装 $name${NC}"
  
  # 备份现有文件/目录
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo -e "${YELLOW}  备份现有配置${NC}"
    mv "$target" "${target}.backup.$(date +%Y%m%d_%H%M%S)"
  fi
  
  # 删除现有软链接
  [ -L "$target" ] && rm "$target"
  
  # 创建软链接
  ln -sf "$source" "$target"
  echo -e "${GREEN}  ✓ 创建软链接: $target -> $source${NC}\n"
}

echo -e "${BLUE}=== 安装 ~/.config 下的配置 ===${NC}\n"

# ~/.config 下的配置目录（整个目录软链接）
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
  if [ -d "$DOTFILES_DIR/$dir" ]; then
    create_symlink "$DOTFILES_DIR/$dir" "$HOME/.config/$dir" "$dir"
  fi
done

echo -e "${BLUE}=== 安装 ~ 目录下的配置文件 ===${NC}\n"

# ~ 目录下的配置文件（单个文件软链接）
# 终端配置
[ -f "$DOTFILES_DIR/terminal/.zshrc" ] && \
  create_symlink "$DOTFILES_DIR/terminal/.zshrc" "$HOME/.zshrc" ".zshrc"

[ -f "$DOTFILES_DIR/terminal/.bashrc" ] && \
  create_symlink "$DOTFILES_DIR/terminal/.bashrc" "$HOME/.bashrc" ".bashrc"

[ -f "$DOTFILES_DIR/terminal/.bash_profile" ] && \
  create_symlink "$DOTFILES_DIR/terminal/.bash_profile" "$HOME/.bash_profile" ".bash_profile"

[ -f "$DOTFILES_DIR/terminal/.profile" ] && \
  create_symlink "$DOTFILES_DIR/terminal/.profile" "$HOME/.profile" ".profile"

# Git 配置
[ -f "$DOTFILES_DIR/git/.gitconfig" ] && \
  create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig" ".gitconfig"

[ -f "$DOTFILES_DIR/git/.gitignore" ] && \
  create_symlink "$DOTFILES_DIR/git/.gitignore" "$HOME/.gitignore" ".gitignore"

[ -f "$DOTFILES_DIR/git/.git_me" ] && \
  create_symlink "$DOTFILES_DIR/git/.git_me" "$HOME/.git_me" ".git_me"

[ -f "$DOTFILES_DIR/git/.git_wk" ] && \
  create_symlink "$DOTFILES_DIR/git/.git_wk" "$HOME/.git_wk" ".git_wk"

[ -f "$DOTFILES_DIR/git/.git_os" ] && \
  create_symlink "$DOTFILES_DIR/git/.git_os" "$HOME/.git_os" ".git_os"

[ -f "$DOTFILES_DIR/git/.git_cc" ] && \
  create_symlink "$DOTFILES_DIR/git/.git_cc" "$HOME/.git_cc" ".git_cc"

# Vim 配置
[ -f "$DOTFILES_DIR/vim/.vimrc" ] && \
  create_symlink "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc" ".vimrc"

echo -e "${BLUE}=== 安装 VSCode 系列 IDE 配置 ===${NC}\n"

# VSCode 系列 IDE 配置
VSCODE_IDES=(
  "Kiro"
  "Cursor"
  "Trae CN"
  "Trae"
  "Antigravity"
  "Comate"
  "Code"
)

for ide in "${VSCODE_IDES[@]}"; do
  IDE_DIR="$HOME/Library/Application Support/$ide/User"
  
  if [ -d "$IDE_DIR" ]; then
    [ -f "$DOTFILES_DIR/vscode/keybindings.json" ] && \
      create_symlink "$DOTFILES_DIR/vscode/keybindings.json" "$IDE_DIR/keybindings.json" "$ide keybindings"
    
    [ -f "$DOTFILES_DIR/vscode/settings.json" ] && \
      create_symlink "$DOTFILES_DIR/vscode/settings.json" "$IDE_DIR/settings.json" "$ide settings"
  fi
done

echo -e "${GREEN}"
echo "╔════════════════════════════════════════╗"
echo "║   ✓ 所有配置安装完成！                 ║"
echo "╚════════════════════════════════════════╝"
echo -e "${NC}\n"

echo -e "${YELLOW}提示：${NC}"
echo -e "  1. 重启终端使配置生效: ${BLUE}source ~/.zshrc${NC}"
echo -e "  2. 重启相关应用（Neovim、WezTerm 等）"
echo -e "  3. 验证软链接: ${BLUE}ls -la ~/.config/nvim${NC}"
echo -e "  4. 验证软链接: ${BLUE}ls -la ~/.zshrc${NC}\n"
