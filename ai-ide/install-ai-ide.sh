#!/usr/bin/env zsh

# AI IDE 配置安装脚本
# 支持 Kiro, Cursor, Windsurf 等主流 AI IDE

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

DOTFILES_DIR="$( cd "$( dirname "${(%):-%x}" )" && pwd )"
TARGET_DIR=""

# AI IDE 配置目录映射
typeset -A IDE_CONFIG_DIRS=(
  kiro .kiro
  cursor .cursor
  windsurf .windsurf
  trae .trae
  trae-cn .trae
  antigravity .antigravity
  comate .comate
  codebuddy .codebuddy
  lingma .lingma
)

# 显示帮助信息
show_help() {
  echo -e "${BLUE}用法:${NC}"
  echo -e "  ./install-ai-ide.sh [目标目录] [IDE...]"
  echo ""
  echo -e "${BLUE}支持的 IDE:${NC}"
  for ide in ${(k)IDE_CONFIG_DIRS}; do
    echo -e "  - $ide"
  done | sort
  echo ""
  echo -e "${BLUE}示例:${NC}"
  echo -e "  ./install-ai-ide.sh ~/workspace/myproject              # 自动检测并安装到指定项目"
  echo -e "  ./install-ai-ide.sh ~/workspace/myproject kiro         # 安装到指定项目的 Kiro"
  echo -e "  ./install-ai-ide.sh ~/workspace/myproject kiro cursor  # 安装到多个 IDE"
  echo -e "  ./install-ai-ide.sh .                                  # 安装到当前目录"
  echo ""
}

# 创建软链接
create_symlink() {
  local source=$1
  local target=$2
  local name=$3
  
  # 如果已经是正确的软链接,跳过
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    echo -e "${GREEN}  ✓ $name 已存在正确的软链接${NC}"
    return
  fi
  
  # 备份现有文件/目录
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo -e "${YELLOW}  备份现有 $name${NC}"
    mv "$target" "${target}.backup.$(date +%Y%m%d_%H%M%S)"
  fi
  
  # 删除现有软链接
  [ -L "$target" ] && rm "$target"
  
  # 创建目标目录(如果不存在)
  mkdir -p "$(dirname "$target")"
  
  # 创建软链接
  ln -sf "$source" "$target"
  echo -e "${GREEN}  ✓ 创建 $name 软链接${NC}"
}

# 安装到指定 IDE
install_to_ide() {
  local ide=$1
  local config_dir="${IDE_CONFIG_DIRS[$ide]}"
  
  if [ -z "$config_dir" ]; then
    echo -e "${RED}错误: 不支持的 IDE '$ide'${NC}"
    return 1
  fi
  
  local target_dir="$TARGET_DIR/$config_dir"
  
  echo -e "${BLUE}=== 安装到 $ide ===${NC}"
  
  # 检查是否存在配置目录
  if [ ! -d "$target_dir" ]; then
    echo -e "${YELLOW}创建配置目录: $target_dir${NC}"
    mkdir -p "$target_dir"
  fi
  
  # 安装 steering 规则
  if [ -d "$DOTFILES_DIR/steering" ]; then
    echo -e "${YELLOW}安装 Steering 规则...${NC}"
    for steering_file in "$DOTFILES_DIR/steering"/*.md; do
      if [ -f "$steering_file" ]; then
        filename=$(basename "$steering_file")
        create_symlink "$steering_file" "$target_dir/steering/$filename" "steering/$filename"
      fi
    done
  fi
  
  # 安装 skills
  if [ -d "$DOTFILES_DIR/skills" ]; then
    echo -e "${YELLOW}安装 Skills...${NC}"
    for skill_dir in "$DOTFILES_DIR/skills"/*; do
      if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")
        create_symlink "$skill_dir" "$target_dir/skills/$skill_name" "skills/$skill_name"
      fi
    done
  fi
  
  echo -e "${GREEN}✓ $ide 安装完成${NC}\n"
}

# 自动检测项目使用的 IDE
detect_ide() {
  local detected=()
  
  for ide in ${(k)IDE_CONFIG_DIRS}; do
    config_dir="${IDE_CONFIG_DIRS[$ide]}"
    if [ -d "$TARGET_DIR/$config_dir" ]; then
      detected+=("$ide")
    fi
  done
  
  echo "${detected[@]}"
}

# 主程序
main() {
  echo -e "${GREEN}"
  echo "╔════════════════════════════════════════╗"
  echo "║   AI IDE 配置安装                      ║"
  echo "╚════════════════════════════════════════╝"
  echo -e "${NC}\n"
  
  # 解析参数
  if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
  fi
  
  # 第一个参数是目标目录
  if [ $# -eq 0 ]; then
    echo -e "${RED}错误: 请指定目标项目目录${NC}\n"
    show_help
    exit 1
  fi
  
  TARGET_DIR="$(cd "$1" 2>/dev/null && pwd || echo "$1")"
  
  # 验证目标目录
  if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}错误: 目标目录不存在: $TARGET_DIR${NC}\n"
    exit 1
  fi
  
  if [ "$TARGET_DIR" = "$HOME" ]; then
    echo -e "${RED}错误: 不能安装到 HOME 目录，请指定具体的项目目录${NC}\n"
    exit 1
  fi
  
  echo -e "${BLUE}目标目录: ${NC}$TARGET_DIR\n"
  
  shift  # 移除第一个参数（目标目录）
  
  # 解析 IDE 参数
  if [ $# -eq 0 ]; then
    # 自动检测
    echo -e "${YELLOW}自动检测项目使用的 IDE...${NC}\n"
    detected_ides=($(detect_ide))
    
    if [ ${#detected_ides[@]} -eq 0 ]; then
      echo -e "${YELLOW}未检测到任何 AI IDE 配置目录${NC}"
      echo -e "${YELLOW}请手动指定 IDE 或先创建配置目录${NC}\n"
      show_help
      exit 0
    fi
    
    echo -e "${GREEN}检测到以下 IDE:${NC}"
    for ide in "${detected_ides[@]}"; do
      echo -e "  - $ide"
    done
    echo ""
    
    # 安装到检测到的 IDE
    for ide in "${detected_ides[@]}"; do
      install_to_ide "$ide"
    done
  else
    # 安装到指定的 IDE
    for ide in "$@"; do
      install_to_ide "$ide"
    done
  fi
  
  echo -e "${GREEN}"
  echo "╔════════════════════════════════════════╗"
  echo "║   ✓ 安装完成!                          ║"
  echo "╚════════════════════════════════════════╝"
  echo -e "${NC}\n"
  
  echo -e "${YELLOW}提示:${NC}"
  echo -e "  1. 重启 IDE 使配置生效"
  echo -e "  2. 验证软链接: ${BLUE}ls -la $TARGET_DIR/.kiro/skills${NC}"
  echo -e "  3. 可用的 skills:"
  echo -e "     - ${BLUE}geekmo-practice${NC}: 实战文章风格（问题解决、经验分享）"
  echo -e "     - ${BLUE}geekmo-course${NC}: 教程文章风格（系统化知识讲解）"
  echo -e "  4. 使用方法:"
  echo -e "     - 实战文章: ${BLUE}用 geekmo-practice 风格写一篇...${NC}"
  echo -e "     - 教程文章: ${BLUE}用 geekmo-course 风格写一篇 Go 函数教程${NC}\n"
}

main "$@"
