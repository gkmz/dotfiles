#!/bin/bash

# VSCode 系列 IDE 配置备份脚本
# 用途：备份所有 IDE 的现有配置

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# IDE 配置目录列表
declare -a IDE_DIRS=(
  "$HOME/Library/Application Support/Kiro/User"
  "$HOME/Library/Application Support/Cursor/User"
  "$HOME/Library/Application Support/Trae/User"
  "$HOME/Library/Application Support/Antigravity/User"
  "$HOME/Library/Application Support/Code/User"
)

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo -e "${GREEN}=== VSCode 系列 IDE 配置备份 ===${NC}\n"

# 遍历所有 IDE 目录
for ide_dir in "${IDE_DIRS[@]}"; do
  ide_name=$(basename "$(dirname "$ide_dir")")
  
  echo -e "${YELLOW}备份 $ide_name...${NC}"
  
  # 检查目录是否存在
  if [ ! -d "$ide_dir" ]; then
    echo -e "${YELLOW}  跳过: 目录不存在${NC}\n"
    continue
  fi
  
  # 备份 keybindings.json
  if [ -f "$ide_dir/keybindings.json" ]; then
    cp "$ide_dir/keybindings.json" "$ide_dir/keybindings.json.backup.$TIMESTAMP"
    echo -e "${GREEN}  ✓ 备份 keybindings.json${NC}"
  fi
  
  # 备份 settings.json
  if [ -f "$ide_dir/settings.json" ]; then
    cp "$ide_dir/settings.json" "$ide_dir/settings.json.backup.$TIMESTAMP"
    echo -e "${GREEN}  ✓ 备份 settings.json${NC}"
  fi
  
  echo ""
done

echo -e "${GREEN}=== 备份完成 ===${NC}"
echo -e "\n备份文件后缀: .backup.$TIMESTAMP\n"
