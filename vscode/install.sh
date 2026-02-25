#!/bin/bash

# VSCode 系列 IDE 统一配置安装脚本
# 用途：创建软链接，将统一配置应用到所有 IDE

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 配置文件
KEYBINDINGS_SOURCE="$SCRIPT_DIR/keybindings.json"
SETTINGS_SOURCE="$SCRIPT_DIR/settings.json"

# IDE 配置目录列表
declare -a IDE_DIRS=(
  "$HOME/Library/Application Support/Kiro/User"
  "$HOME/Library/Application Support/Cursor/User"
  "$HOME/Library/Application Support/Trae/User"
  "$HOME/Library/Application Support/Antigravity/User"
  "$HOME/Library/Application Support/Code/User"
)

echo -e "${GREEN}=== VSCode 系列 IDE 统一配置安装 ===${NC}\n"

# 检查源文件是否存在
if [ ! -f "$KEYBINDINGS_SOURCE" ]; then
  echo -e "${RED}错误: keybindings.json 不存在${NC}"
  exit 1
fi

if [ ! -f "$SETTINGS_SOURCE" ]; then
  echo -e "${RED}错误: settings.json 不存在${NC}"
  exit 1
fi

# 函数：创建软链接
create_symlink() {
  local source=$1
  local target=$2
  local ide_name=$3
  
  # 如果目标文件存在且不是软链接，先备份
  if [ -f "$target" ] && [ ! -L "$target" ]; then
    backup_file="${target}.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}  备份原文件: $backup_file${NC}"
    cp "$target" "$backup_file"
  fi
  
  # 删除现有文件或软链接
  if [ -e "$target" ] || [ -L "$target" ]; then
    rm "$target"
  fi
  
  # 创建软链接
  ln -s "$source" "$target"
  echo -e "${GREEN}  ✓ 创建软链接成功${NC}"
}

# 遍历所有 IDE 目录
for ide_dir in "${IDE_DIRS[@]}"; do
  ide_name=$(basename "$(dirname "$ide_dir")")
  
  echo -e "${YELLOW}处理 $ide_name...${NC}"
  
  # 检查目录是否存在
  if [ ! -d "$ide_dir" ]; then
    echo -e "${YELLOW}  跳过: 目录不存在${NC}\n"
    continue
  fi
  
  # 创建 keybindings.json 软链接
  echo "  配置快捷键..."
  create_symlink "$KEYBINDINGS_SOURCE" "$ide_dir/keybindings.json" "$ide_name"
  
  # 创建 settings.json 软链接
  echo "  配置设置..."
  create_symlink "$SETTINGS_SOURCE" "$ide_dir/settings.json" "$ide_name"
  
  echo ""
done

echo -e "${GREEN}=== 安装完成 ===${NC}"
echo -e "\n提示："
echo -e "  1. 所有配置已通过软链接同步"
echo -e "  2. 修改 $SCRIPT_DIR 下的配置文件，所有 IDE 会自动同步"
echo -e "  3. 原有配置已备份，文件名带 .backup 后缀"
echo -e "  4. 如需恢复，运行: ./uninstall.sh\n"
