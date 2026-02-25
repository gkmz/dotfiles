#!/bin/bash

# Dotfiles 安装脚本（模块化版本）
# 用途：支持全量安装和增量安装

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 显示帮助信息
show_help() {
  echo -e "${BLUE}用法：${NC}"
  echo -e "  ./install.sh [选项] [模块...]"
  echo ""
  echo -e "${BLUE}选项：${NC}"
  echo -e "  -h, --help     显示帮助信息"
  echo -e "  -l, --list     列出所有可用模块"
  echo -e "  -a, --all      安装所有模块（默认）"
  echo ""
  echo -e "${BLUE}可用模块：${NC}"
  echo -e "  config         ~/.config 下的配置（nvim, wezterm 等）"
  echo -e "  terminal       终端配置（.zshrc, .bashrc 等）"
  echo -e "  git            Git 配置（.gitconfig 等）"
  echo -e "  vim            Vim 配置（.vimrc）"
  echo -e "  vscode         VSCode 系列 IDE 配置"
  echo ""
  echo -e "${BLUE}示例：${NC}"
  echo -e "  ./install.sh                    # 安装所有模块"
  echo -e "  ./install.sh terminal git       # 只安装 terminal 和 git"
  echo -e "  ./install.sh vscode             # 只安装 VSCode 系列 IDE"
  echo -e "  ./install.sh -l                 # 列出所有模块"
  echo ""
}

# 列出所有模块
list_modules() {
  echo -e "${BLUE}可用模块：${NC}"
  echo -e "  ${GREEN}✓${NC} config    - ~/.config 下的配置"
  echo -e "  ${GREEN}✓${NC} terminal  - 终端配置"
  echo -e "  ${GREEN}✓${NC} git       - Git 配置"
  echo -e "  ${GREEN}✓${NC} vim       - Vim 配置"
  echo -e "  ${GREEN}✓${NC} vscode    - VSCode 系列 IDE 配置"
  echo ""
}

# 函数：创建软链接
create_symlink() {
  local source=$1
  local target=$2
  local name=$3
  
  echo -e "${YELLOW}安装 $name${NC}"
  
  # 如果已经是正确的软链接，跳过
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    echo -e "${GREEN}  ✓ 已存在正确的软链接，跳过${NC}\n"
    return
  fi
  
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

# 模块：安装 ~/.config 下的配置
install_config() {
  echo -e "${BLUE}=== 安装 ~/.config 下的配置 ===${NC}\n"
  
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
}

# 模块：安装终端配置
install_terminal() {
  echo -e "${BLUE}=== 安装终端配置 ===${NC}\n"
  
  [ -f "$DOTFILES_DIR/terminal/.zshrc" ] && \
    create_symlink "$DOTFILES_DIR/terminal/.zshrc" "$HOME/.zshrc" ".zshrc"
  
  [ -f "$DOTFILES_DIR/terminal/.bashrc" ] && \
    create_symlink "$DOTFILES_DIR/terminal/.bashrc" "$HOME/.bashrc" ".bashrc"
  
  [ -f "$DOTFILES_DIR/terminal/.bash_profile" ] && \
    create_symlink "$DOTFILES_DIR/terminal/.bash_profile" "$HOME/.bash_profile" ".bash_profile"
  
  [ -f "$DOTFILES_DIR/terminal/.profile" ] && \
    create_symlink "$DOTFILES_DIR/terminal/.profile" "$HOME/.profile" ".profile"
}

# 模块：安装 Git 配置
install_git() {
  echo -e "${BLUE}=== 安装 Git 配置 ===${NC}\n"
  
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
}

# 模块：安装 Vim 配置
install_vim() {
  echo -e "${BLUE}=== 安装 Vim 配置 ===${NC}\n"
  
  [ -f "$DOTFILES_DIR/vim/.vimrc" ] && \
    create_symlink "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc" ".vimrc"
}

# 模块：安装 VSCode 系列 IDE 配置
install_vscode() {
  echo -e "${BLUE}=== 安装 VSCode 系列 IDE 配置 ===${NC}\n"
  
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
  
  # 检测已安装的 IDE
  INSTALLED_IDES=()
  for ide in "${VSCODE_IDES[@]}"; do
    IDE_DIR="$HOME/Library/Application Support/$ide/User"
    if [ -d "$IDE_DIR" ]; then
      INSTALLED_IDES+=("$ide")
    fi
  done
  
  if [ ${#INSTALLED_IDES[@]} -eq 0 ]; then
    echo -e "${YELLOW}未检测到已安装的 VSCode 系列 IDE，跳过${NC}\n"
    return
  fi
  
  echo -e "${YELLOW}检测到以下已安装的 IDE：${NC}"
  for i in "${!INSTALLED_IDES[@]}"; do
    echo -e "  $((i+1)). ${INSTALLED_IDES[$i]}"
  done
  echo ""
  
  echo -e "${YELLOW}请选择要安装配置的 IDE（多选用空格分隔，如：1 3 5，输入 'all' 安装全部，直接回车跳过）：${NC}"
  read -r selection
  
  if [ -z "$selection" ]; then
    echo -e "${YELLOW}跳过 VSCode 系列 IDE 配置安装${NC}\n"
    return
  fi
  
  if [ "$selection" = "all" ]; then
    # 安装所有已检测到的 IDE
    for ide in "${INSTALLED_IDES[@]}"; do
      IDE_DIR="$HOME/Library/Application Support/$ide/User"
      [ -f "$DOTFILES_DIR/vscode/keybindings.json" ] && \
        create_symlink "$DOTFILES_DIR/vscode/keybindings.json" "$IDE_DIR/keybindings.json" "$ide keybindings"
      
      [ -f "$DOTFILES_DIR/vscode/settings.json" ] && \
        create_symlink "$DOTFILES_DIR/vscode/settings.json" "$IDE_DIR/settings.json" "$ide settings"
    done
  else
    # 安装选中的 IDE
    for num in $selection; do
      if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "${#INSTALLED_IDES[@]}" ]; then
        ide="${INSTALLED_IDES[$((num-1))]}"
        IDE_DIR="$HOME/Library/Application Support/$ide/User"
        
        [ -f "$DOTFILES_DIR/vscode/keybindings.json" ] && \
          create_symlink "$DOTFILES_DIR/vscode/keybindings.json" "$IDE_DIR/keybindings.json" "$ide keybindings"
        
        [ -f "$DOTFILES_DIR/vscode/settings.json" ] && \
          create_symlink "$DOTFILES_DIR/vscode/settings.json" "$IDE_DIR/settings.json" "$ide settings"
      fi
    done
  fi
}

# 主程序
main() {
  echo -e "${GREEN}"
  echo "╔════════════════════════════════════════╗"
  echo "║   Dotfiles 配置安装                    ║"
  echo "╚════════════════════════════════════════╝"
  echo -e "${NC}\n"
  
  # 解析参数
  if [ $# -eq 0 ]; then
    # 无参数，安装所有模块
    install_config
    install_terminal
    install_git
    install_vim
    install_vscode
  else
    case "$1" in
      -h|--help)
        show_help
        exit 0
        ;;
      -l|--list)
        list_modules
        exit 0
        ;;
      -a|--all)
        install_config
        install_terminal
        install_git
        install_vim
        install_vscode
        ;;
      *)
        # 安装指定的模块
        for module in "$@"; do
          case "$module" in
            config)
              install_config
              ;;
            terminal)
              install_terminal
              ;;
            git)
              install_git
              ;;
            vim)
              install_vim
              ;;
            vscode)
              install_vscode
              ;;
            *)
              echo -e "${RED}错误：未知模块 '$module'${NC}"
              echo -e "运行 ${BLUE}./install.sh -l${NC} 查看可用模块\n"
              exit 1
              ;;
          esac
        done
        ;;
    esac
  fi
  
  echo -e "${GREEN}"
  echo "╔════════════════════════════════════════╗"
  echo "║   ✓ 安装完成！                         ║"
  echo "╚════════════════════════════════════════╝"
  echo -e "${NC}\n"
  
  echo -e "${YELLOW}提示：${NC}"
  echo -e "  1. 重启终端使配置生效: ${BLUE}source ~/.zshrc${NC}"
  echo -e "  2. 重启相关应用（Neovim、WezTerm 等）"
  echo -e "  3. 验证软链接: ${BLUE}ls -la ~/.config/nvim${NC}"
  echo -e "  4. 增量安装: ${BLUE}./install.sh vscode${NC}\n"
}

main "$@"
