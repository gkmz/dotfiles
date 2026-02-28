#!/usr/bin/env zsh

# AI IDE 配置验证脚本

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

TARGET_DIR=""

# 显示帮助信息
show_help() {
  echo -e "${BLUE}用法:${NC}"
  echo -e "  ./verify-install.sh [目标目录]"
  echo ""
  echo -e "${BLUE}示例:${NC}"
  echo -e "  ./verify-install.sh ~/workspace/myproject"
  echo -e "  ./verify-install.sh ."
  echo ""
}

# 检查软链接
check_symlink() {
  local target=$1
  local name=$2
  
  if [ ! -e "$target" ]; then
    echo -e "${RED}  ✗ $name 不存在${NC}"
    return 1
  fi
  
  if [ ! -L "$target" ]; then
    echo -e "${YELLOW}  ⚠ $name 不是软链接${NC}"
    return 1
  fi
  
  local link_target=$(readlink "$target")
  if [ ! -e "$link_target" ]; then
    echo -e "${RED}  ✗ $name 软链接失效: $link_target${NC}"
    return 1
  fi
  
  echo -e "${GREEN}  ✓ $name${NC} -> ${BLUE}$link_target${NC}"
  return 0
}

# 验证 IDE 配置
verify_ide() {
  local ide=$1
  local config_dir=$2
  local target_dir="$TARGET_DIR/$config_dir"
  
  if [ ! -d "$target_dir" ]; then
    return 1
  fi
  
  echo -e "\n${BLUE}=== 验证 $ide ===${NC}"
  
  local has_error=0
  
  # 检查 skills
  if [ -d "$target_dir/skills" ]; then
    echo -e "${YELLOW}Skills:${NC}"
    for skill in geekmo-practice geekmo-course; do
      if ! check_symlink "$target_dir/skills/$skill" "$skill"; then
        has_error=1
      fi
    done
  else
    echo -e "${YELLOW}Skills 目录不存在${NC}"
  fi
  
  # 检查 steering
  if [ -d "$target_dir/steering" ]; then
    echo -e "\n${YELLOW}Steering:${NC}"
    local steering_count=0
    for steering_file in "$target_dir/steering"/*.md; do
      if [ -f "$steering_file" ]; then
        filename=$(basename "$steering_file")
        if ! check_symlink "$steering_file" "$filename"; then
          has_error=1
        fi
        ((steering_count++))
      fi
    done
    if [ $steering_count -eq 0 ]; then
      echo -e "${YELLOW}  没有 steering 文件${NC}"
    fi
  else
    echo -e "\n${YELLOW}Steering 目录不存在${NC}"
  fi
  
  if [ $has_error -eq 0 ]; then
    echo -e "\n${GREEN}✓ $ide 配置正常${NC}"
  else
    echo -e "\n${RED}✗ $ide 配置有问题${NC}"
  fi
  
  return $has_error
}

# 主程序
main() {
  echo -e "${GREEN}"
  echo "╔════════════════════════════════════════╗"
  echo "║   AI IDE 配置验证                      ║"
  echo "╚════════════════════════════════════════╝"
  echo -e "${NC}\n"
  
  # 解析参数
  if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
  fi
  
  if [ $# -eq 0 ]; then
    echo -e "${RED}错误: 请指定目标项目目录${NC}\n"
    show_help
    exit 1
  fi
  
  TARGET_DIR="$(cd "$1" 2>/dev/null && pwd || echo "$1")"
  
  if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}错误: 目标目录不存在: $TARGET_DIR${NC}\n"
    exit 1
  fi
  
  echo -e "${BLUE}目标目录: ${NC}$TARGET_DIR\n"
  
  # 检测并验证所有 IDE
  local found_ide=0
  local has_error=0
  
  typeset -A IDE_CONFIG_DIRS=(
    kiro .kiro
    cursor .cursor
    windsurf .windsurf
    trae .trae
    antigravity .antigravity
    comate .comate
    codebuddy .codebuddy
    lingma .lingma
  )
  
  for ide in ${(k)IDE_CONFIG_DIRS}; do
    config_dir="${IDE_CONFIG_DIRS[$ide]}"
    if [ -d "$TARGET_DIR/$config_dir" ]; then
      found_ide=1
      if ! verify_ide "$ide" "$config_dir"; then
        has_error=1
      fi
    fi
  done
  
  if [ $found_ide -eq 0 ]; then
    echo -e "${YELLOW}未检测到任何 AI IDE 配置目录${NC}\n"
    exit 0
  fi
  
  echo -e "\n${GREEN}"
  echo "╔════════════════════════════════════════╗"
  if [ $has_error -eq 0 ]; then
    echo "║   ✓ 验证完成，所有配置正常!            ║"
  else
    echo "║   ⚠ 验证完成，发现一些问题             ║"
  fi
  echo "╚════════════════════════════════════════╝"
  echo -e "${NC}\n"
  
  if [ $has_error -ne 0 ]; then
    echo -e "${YELLOW}建议:${NC}"
    echo -e "  重新运行安装脚本修复问题:"
    echo -e "  ${BLUE}./install-ai-ide.sh $TARGET_DIR${NC}\n"
    exit 1
  fi
}

main "$@"
