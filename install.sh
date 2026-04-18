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
  echo -e "  codex          Codex 配置（~/.codex 下必要文件）"
  echo -e "  claude         Claude Code 配置（~/.claude 软链接）"
  echo -e "  vscode         VSCode 系列 IDE 配置"
  echo -e "  ai-ide         AI IDE 配置（Kiro, Cursor 等）"
  echo -e "  accio          Accio 配置（~/.accio 软链接）"
  echo -e "  rime           鼠须管 Rime 配置（~/Library/Rime 软链接）"
  echo -e "  tools          安装外部工具依赖（npm, brew 等）"
  echo ""
  echo -e "${BLUE}示例：${NC}"
  echo -e "  ./install.sh                    # 安装所有模块"
  echo -e "  ./install.sh terminal git       # 只安装 terminal 和 git"
  echo -e "  ./install.sh codex              # 只安装 Codex 配置"
  echo -e "  ./install.sh claude             # 只安装 Claude 配置"
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
  echo -e "  ${GREEN}✓${NC} codex     - Codex 配置（~/.codex 下必要文件）"
  echo -e "  ${GREEN}✓${NC} claude    - Claude Code 配置（~/.claude 软链接）"
  echo -e "  ${GREEN}✓${NC} vscode    - VSCode 系列 IDE 配置"
  echo -e "  ${GREEN}✓${NC} ai-ide    - AI IDE 配置（Kiro, Cursor 等）"
  echo -e "  ${GREEN}✓${NC} accio     - Accio 配置（~/.accio 软链接）"
  echo -e "  ${GREEN}✓${NC} rime      - 鼠须管 Rime（~/Library/Rime）"
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

# 模块：安装 Codex 配置
install_codex() {
  echo -e "${BLUE}=== 安装 Codex 配置 ===${NC}\n"

  mkdir -p "$HOME/.codex/rules"

  [ -f "$DOTFILES_DIR/codex/config.toml" ] && \
    create_symlink "$DOTFILES_DIR/codex/config.toml" "$HOME/.codex/config.toml" "codex config.toml"

  [ -f "$DOTFILES_DIR/codex/mcp_config.json" ] && \
    create_symlink "$DOTFILES_DIR/codex/mcp_config.json" "$HOME/.codex/mcp_config.json" "codex mcp_config.json"

  [ -f "$DOTFILES_DIR/codex/rules/default.rules" ] && \
    create_symlink "$DOTFILES_DIR/codex/rules/default.rules" "$HOME/.codex/rules/default.rules" "codex default.rules"
}

# 模块：安装 Claude Code 配置
install_claude() {
  echo -e "${BLUE}=== 安装 Claude Code 配置 ===${NC}\n"

  [ -d "$DOTFILES_DIR/claude" ] && \
    create_symlink "$DOTFILES_DIR/claude" "$HOME/.claude" "claude"
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

# 模块：安装 Accio 配置
install_accio() {
  echo -e "${BLUE}=== 安装 Accio 配置 ===${NC}\n"

  local accio_src="$DOTFILES_DIR/accio"
  local accio_dst="$HOME/.accio"

  if [ ! -d "$accio_src" ]; then
    echo -e "${RED}错误：未找到 accio 目录${NC}\n"
    return 1
  fi

  # 如果 ~/.accio 已经是正确的软链接，跳过
  if [ -L "$accio_dst" ] && [ "$(readlink "$accio_dst")" = "$accio_src" ]; then
    echo -e "${GREEN}  ✓ 已存在正确的软链接，跳过${NC}\n"
    return
  fi

  # 如果 ~/.accio 是真实目录，将运行时数据合并回来后再建软链
  if [ -d "$accio_dst" ] && [ ! -L "$accio_dst" ]; then
    echo -e "${YELLOW}  检测到真实目录 $accio_dst，正在合并运行时数据...${NC}"

    # 将运行时目录/文件从原 ~/.accio 保留到 dotfiles 目录之外的临时位置，
    # 安装后再还原。策略：把整个原目录移走，建软链后，把运行时数据写回软链目录。
    local backup_dir="${accio_dst}.backup.$(date +%Y%m%d_%H%M%S)"
    mv "$accio_dst" "$backup_dir"
    echo -e "${YELLOW}  原目录已备份至 $backup_dir${NC}"

    # 建软链
    ln -sf "$accio_src" "$accio_dst"
    echo -e "${GREEN}  ✓ 创建软链接: $accio_dst -> $accio_src${NC}"

    # 还原运行时目录/文件（覆盖到软链目录，即写回 dotfiles/accio/）
    local RUNTIME_ITEMS=(
      "logs"
      "bin"
      "network"
      "model_cache.json"
      "onboarding_cache.json"
      "utdid"
    )
    for item in "${RUNTIME_ITEMS[@]}"; do
      if [ -e "$backup_dir/$item" ]; then
        cp -r "$backup_dir/$item" "$accio_dst/"
      fi
    done

    # 还原各 account 下的运行时数据（conversations/sessions/tasks 等）
    for account_dir in "$backup_dir/accounts"/*/; do
      local account=$(basename "$account_dir")
      local ACCOUNT_RUNTIME=(
        "conversations"
        "channels"
        "tasks"
        "pairings"
        "pairings-viewed.json"
        "mcp_oauth"
        "workspaces"
        "subagent-sessions"
      )
      for item in "${ACCOUNT_RUNTIME[@]}"; do
        if [ -e "$account_dir/$item" ]; then
          mkdir -p "$accio_dst/accounts/$account"
          cp -r "$account_dir/$item" "$accio_dst/accounts/$account/"
        fi
      done

      # 还原各 agent 下的运行时数据
      for agent_dir in "$account_dir/agents"/*/; do
        local agent=$(basename "$agent_dir")
        local AGENT_RUNTIME=(
          "sessions"
          "subagent-sessions"
          "runtime"
          "project"
          "msg-queue"
        )
        for item in "${AGENT_RUNTIME[@]}"; do
          if [ -e "$agent_dir/$item" ]; then
            mkdir -p "$accio_dst/accounts/$account/agents/$agent"
            cp -r "$agent_dir/$item" "$accio_dst/accounts/$account/agents/$agent/"
          fi
        done
        # 还原 agent-core/diary 和 HEARTBEAT.md
        if [ -d "$agent_dir/agent-core/diary" ]; then
          mkdir -p "$accio_dst/accounts/$account/agents/$agent/agent-core"
          cp -r "$agent_dir/agent-core/diary" "$accio_dst/accounts/$account/agents/$agent/agent-core/"
        fi
        if [ -f "$agent_dir/agent-core/HEARTBEAT.md" ]; then
          mkdir -p "$accio_dst/accounts/$account/agents/$agent/agent-core"
          cp "$agent_dir/agent-core/HEARTBEAT.md" "$accio_dst/accounts/$account/agents/$agent/agent-core/"
        fi
        # 还原 agent-core/skills/skills.jsonc
        if [ -f "$agent_dir/agent-core/skills/skills.jsonc" ]; then
          mkdir -p "$accio_dst/accounts/$account/agents/$agent/agent-core/skills"
          cp "$agent_dir/agent-core/skills/skills.jsonc" "$accio_dst/accounts/$account/agents/$agent/agent-core/skills/"
        fi
        # 还原 audit.jsonl
        for perm_audit in "$agent_dir/permissions/audit.jsonl"; do
          if [ -f "$perm_audit" ]; then
            mkdir -p "$accio_dst/accounts/$account/agents/$agent/permissions"
            cp "$perm_audit" "$accio_dst/accounts/$account/agents/$agent/permissions/"
          fi
        done
      done
    done

    echo -e "${GREEN}  ✓ 运行时数据已还原${NC}"
    echo -e "${YELLOW}  备份保留在 $backup_dir，确认无误后可手动删除${NC}\n"
  else
    # 删除现有软链（若指向别处）
    [ -L "$accio_dst" ] && rm "$accio_dst"
    ln -sf "$accio_src" "$accio_dst"
    echo -e "${GREEN}  ✓ 创建软链接: $accio_dst -> $accio_src${NC}\n"
  fi
}

# 模块：鼠须管（Squirrel）Rime 用户目录软链接
install_rime() {
  echo -e "${BLUE}=== 安装 Rime（鼠须管）用户配置 ===${NC}\n"

  local rime_dst="$HOME/Library/Rime"
  mkdir -p "$rime_dst/lua"

  local -a rime_links=(
    "default.custom.yaml"
    "hank_luna_pinyin.schema.yaml"
    "radical_lookup.dict.yaml"
    "hank_pinyin_simp.schema.yaml"
    "luna_pinyin.custom.yaml"
    "luna_pinyin_simp.schema.yaml"
    "luna_pinyin_simp.custom.yaml"
    "squirrel.custom.yaml"
    "custom_phrase.txt"
  )
  local f
  for f in "${rime_links[@]}"; do
    if [ -f "$DOTFILES_DIR/rime/$f" ]; then
      create_symlink "$DOTFILES_DIR/rime/$f" "$rime_dst/$f" "rime $f"
    fi
  done

  if [ -f "$DOTFILES_DIR/rime/lua/date_time.lua" ]; then
    create_symlink "$DOTFILES_DIR/rime/lua/date_time.lua" "$rime_dst/lua/date_time.lua" "rime lua/date_time.lua"
  fi
  if [ -f "$DOTFILES_DIR/rime/lua/radical_lookup.lua" ]; then
    create_symlink "$DOTFILES_DIR/rime/lua/radical_lookup.lua" "$rime_dst/lua/radical_lookup.lua" "rime lua/radical_lookup.lua"
  fi

  # rime.lua 是 librime-lua 常见入口；用于注册 lua_translator@date_time 等函数
  if [ -f "$DOTFILES_DIR/rime/rime.lua" ]; then
    create_symlink "$DOTFILES_DIR/rime/rime.lua" "$rime_dst/rime.lua" "rime rime.lua"
  fi

  echo -e "${YELLOW}可选插件（Git SSH 克隆）：${BLUE}$DOTFILES_DIR/rime/install-plugins.sh english|emoji|all${YELLOW}，然后鼠须管「重新部署」${NC}\n"
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
    install_codex
    install_claude
    install_vscode
    install_accio
    install_rime
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
        install_codex
        install_claude
        install_vscode
        install_accio
        install_rime
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
            codex)
              install_codex
              ;;
            claude)
              install_claude
              ;;
            vscode)
              install_vscode
              ;;
            ai-ide)
              install_ai_ide
              ;;
            accio)
              install_accio
              ;;
            rime)
              install_rime
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
