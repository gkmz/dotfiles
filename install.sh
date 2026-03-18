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
  echo -e "  ai-ide         AI IDE 配置（Kiro, Cursor 等）"
  echo -e "  tools          安装外部工具依赖（npm, brew 等）"
  echo ""
  echo -e "${BLUE}示例：${NC}"
  echo -e "  ./install.sh                    # 安装所有模块"
  echo -e "  ./install.sh terminal git       # 只安装 terminal 和 git"
  echo -e "  ./install.sh vscode             # 只安装 VSCode 系列 IDE"
  echo -e "  ./install.sh ai-ide             # 只安装 AI IDE 配置"
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
  echo -e "  ${GREEN}✓${NC} ai-ide    - AI IDE 配置（Kiro, Cursor 等）"
  echo -e "  ${GREEN}✓${NC} tools     - 安装外部工具依赖（mmdc 等）"
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
  if [ ! -d "$DOTFILES_DIR/vscode" ]; then
    echo -e "${RED}错误：未找到 vscode 目录${NC}\n"
    return 1
  fi

  # 先生成各 IDE 的合并配置
  echo -e "${YELLOW}生成各 IDE 合并配置（settings/keybindings）...${NC}"
  (cd "$DOTFILES_DIR/vscode" && python generate_ide_configs.py)

  # 再调用 vscode/install.sh，将生成的配置软链接到各 IDE
  if [ -f "$DOTFILES_DIR/vscode/install.sh" ]; then
    echo -e "${YELLOW}应用配置到已安装的 VSCode 系列 IDE...${NC}"
    bash "$DOTFILES_DIR/vscode/install.sh"
  else
    echo -e "${RED}错误：未找到 $DOTFILES_DIR/vscode/install.sh${NC}\n"
  fi
}

# 模块：安装 AI IDE 配置
install_ai_ide() {
  echo -e "${BLUE}=== 安装 AI IDE 配置 ===${NC}\n"
  
  # 检查是否在项目目录中
  if [ "$PWD" = "$DOTFILES_DIR" ]; then
    echo -e "${YELLOW}请在项目目录中运行 AI IDE 安装${NC}"
    echo -e "${YELLOW}示例：${NC}"
    echo -e "  cd /path/to/your/project"
    echo -e "  $DOTFILES_DIR/ai-ide/install-ai-ide.sh"
    echo ""
    return
  fi
  
  # 调用 AI IDE 安装脚本
  if [ -f "$DOTFILES_DIR/ai-ide/install-ai-ide.sh" ]; then
    bash "$DOTFILES_DIR/ai-ide/install-ai-ide.sh"
  else
    echo -e "${RED}错误：找不到 AI IDE 安装脚本${NC}\n"
  fi
}

# 模块：安装外部工具依赖
install_tools() {
  echo -e "${BLUE}=== 安装外部工具依赖 ===${NC}\n"

  # 1. Mermaid CLI (用于 Snacks.image 渲染)
  if ! command -v mmdc &> /dev/null; then
    echo -e "${YELLOW}检测到 mmdc (mermaid-cli) 未安装，正在通过 npm 安装...${NC}"
    if command -v npm &> /dev/null; then
      npm install -g @mermaid-js/mermaid-cli
      echo -e "${GREEN}  ✓ mermaid-cli 安装成功${NC}"
    else
      echo -e "${RED}  ✗ 错误：未找到 npm，请先安装 Node.js${NC}"
    fi
  else
    echo -e "${GREEN}  ✓ mermaid-cli (mmdc) 已安装${NC}"
  fi

  # 也可以在这里增加其他工具的检测，如 luarocks, ripgrep 等
  echo ""
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
    install_tools
    echo -e "${YELLOW}注意：ai-ide 模块需要在项目目录中单独运行${NC}\n"
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
        install_tools
        echo -e "${YELLOW}注意：ai-ide 模块需要在项目目录中单独运行${NC}\n"
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
            ai-ide)
              install_ai_ide
              ;;
            tools)
              install_tools
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
